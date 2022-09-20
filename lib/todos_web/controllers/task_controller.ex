defmodule TodosWeb.TaskController do

    use TodosWeb, :controller
    alias TodosWeb.Task
    alias TodosWeb.Calendar

    plug TodosWeb.Plugs.RequireAuth when action in [:create, :delete, :show]
    
    def index(conn, _params) do
        changeset = Task.changeset(%Task{}, %{})
        render conn, "index.html", changeset: changeset
    end
    def check(conn, changeset) do

        tasks = get_today_task()
        cond do
            Enum.count(tasks)<3 ->
                case Repo.insert(changeset) do
                    {:ok, _task} ->
                        redirect(conn, to: Routes.task_path(conn, :show))
                        
                    {:error, changeset} ->
                        # IO.puts("++++++++++++++++++++++++")
                        # IO.inspect(changeset)
                       render conn, "index.html", changeset: changeset
                end
            true  -> 
                conn
                |> put_flash(:error, "Cannot add more than 3 task")
                |> redirect(to: Routes.task_path(conn, :index))
            
        end
    end

    def create(conn, params) do
        IO.puts("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        #IO.inspect(params)
        %{"task" => task} = params
        # changeset  = Task.changeset(%Task{}, task)
        
       
        changeset = conn.assigns.user
            |> build_assoc(:task)
            |> Task.changeset(task)
        check(conn, changeset)
        
        current_time = NaiveDateTime.utc_now()
        day = current_time.day
        month = current_time.month
        year = current_time.year
        changeset = Calendar.changeset(%Calendar{}, %{day: day, month: month, year: year, status: "Red"})
        # case Repo.get(changeset) do
        #     {:ok, _task} ->
        #         Repo.update(Calendar, changeset)
        #     {:error, changeset} ->
        #         Repo.insert(Calendar, changeset)
        # end 
        Repo.insert(Calendar, changeset)


        # today_task = get_today_task();
        # case Enum.count(today_task) do
        #     1 -> 
            
        #     2 -> 

        #     3 -> 

        
    end
    def get_today_task() do
        current_time = NaiveDateTime.utc_now()
        #IO.puts("++++++++++++++++++++++++")
        #IO.inspect(current_time)
        past_time = 
        current_time
        |> NaiveDateTime.add(-1 * (( current_time.hour * 60 * 60 ) + ( current_time.minute*60 ) + current_time.second) ,  :second)
       
        IO.puts("++++++++++++++++++++++++")
        IO.inspect(past_time)
        
        Task
        |> select([t], %{
            subject: t.subject,
        })
        |> where([e], e.inserted_at >= ^past_time)
        |> where([e], e.inserted_at < ^current_time)
        |> Repo.all
    end



    def delete(conn, %{"id" => task_id}) do

        
        Repo.get!(Task, task_id) |> Repo.delete!
        current_time = NaiveDateTime.utc_now()
        day = current_time.day
        month = current_time.month
        year = current_time.year
        changeset = Calendar.changeset(%Calendar{}, %{day: day, month: month, year: year, status: "Green"})
        # case Repo.get(Calendar) do
        #     {:ok, _task} ->
        #         Repo.update(Calendar, changeset)
        #     {:error, changeset} ->
        #         Repo.insert(Calendar, changeset)
        # end 
        Repo.insert(Calendar, changeset)
        conn
        |> put_flash(:info, "Task Deleted")
        redirect(conn, to: Routes.task_path(conn, :index))
    end

    def show(conn, _params) do
        
        tasks = Repo.all(Task)
        %TodosWeb.User{id: user_id} = conn.assigns.user
        # IO.puts("++++++++++++++++++++++++")
        # IO.inspect(user_id)
        # tasks = Task |> where(id: user_id) |> Repo.all()
        #IO.inspect(tasks)
        render conn, "show.html", tasks: tasks
    end

end