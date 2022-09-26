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
        tasks = Enum.count(check_today_pending_task()) + Enum.count(check_today_done_task())
        cond do
            tasks<3 ->
                case Repo.insert(changeset) do
                    {:ok, _task} ->
                        redirect(conn, to: Routes.task_path(conn, :show))
                    {:error, changeset} ->
                       render conn, "index.html", changeset: changeset
                end
            true  -> 
                conn
                |> put_flash(:error, "Cannot add more than 3 task")
                |> redirect(to: Routes.task_path(conn, :index))
        end
    end

    def calendar_status(color) do
        current_time = NaiveDateTime.utc_now()
        day = current_time.day
        month = current_time.month
        year = current_time.year
        changeset = Calendar.changeset(%Calendar{}, %{day: day, month: month, year: year, status: color})
        case get_date() do
            nil ->
                Repo.insert(changeset)
            day ->
                old_data = Repo.get(Calendar, day.id)
                changeset = Calendar.changeset(old_data, %{status: color})
                Repo.update(changeset)  
        end
    end

    def create(conn, params) do
        %{"task" => task} = params
        changeset = conn.assigns.user
            |> build_assoc(:task)
            |> Task.changeset(task)
        check(conn, changeset)
        done_tasks = check_today_done_task()
        length = Enum.count(done_tasks)
        cond do
            length == 3 ->
                calendar_status("Green")
            length>0 ->
                calendar_status("Yellow")

            Enum.count(done_tasks)==0 ->
                calendar_status("Red")
        end
    end
    def get_today_task() do
        date_query()
        |> Repo.all
    end

    def date_query() do
        current_time = NaiveDateTime.utc_now()
        past_time = 
        current_time
        |> NaiveDateTime.add(-1 * (( current_time.hour * 60 * 60 ) + ( current_time.minute*60 ) + current_time.second) ,  :second)
        Task
        |> select([t], %{
            subject: t.subject,
        })
        |> where([e], e.inserted_at >= ^past_time)
        |> where([e], e.inserted_at < ^current_time)
    end

    def check_today_pending_task() do
        date_query()
        |> where([e], e.done == 0)
        |> Repo.all
    end

    def check_today_done_task() do
        date_query()
        |> where([e], e.done == 1)
        |> Repo.all
    end

     def find_date(day, month, year) do
        Repo.get_by(Calendar, [day: day, month: month, year: year])
    end
    
    def get_date() do
        current_time = NaiveDateTime.utc_now()
        day = current_time.day
        month = current_time.month
        year = current_time.year 
        Repo.get_by(Calendar, [day: day, month: month, year: year])
    end

    def update(conn, %{"id" => task_id}) do
         not_done_task = check_today_pending_task()
        length = Enum.count(not_done_task)
        cond do
            length > 1 ->
                calendar_status("Yellow")
            length == 1 ->
                calendar_status("Green")
        end
        completed_task = Repo.get(Task, task_id);
        newChangeset = Task.changeset(completed_task, %{done: 1})
        Repo.update(newChangeset)
        conn
        |> put_flash(:info, "Task Deleted")
        redirect(conn, to: Routes.task_path(conn, :index))
    end

    def show(conn, _params) do
        current_time = NaiveDateTime.utc_now()
        past_time = 
        current_time
        |> NaiveDateTime.add(-1 * (( current_time.hour * 60 * 60 ) + ( current_time.minute*60 ) + current_time.second) ,  :second)
        tasks = Task
        |> where([e], e.inserted_at >= ^past_time)
        |> where([e], e.inserted_at < ^current_time)
        |> Repo.all
        %TodosWeb.User{id: user_id} = conn.assigns.user
        render conn, "show.html", tasks: tasks
    end
end
