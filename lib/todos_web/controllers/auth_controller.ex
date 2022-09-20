defmodule TodosWeb.AuthController do
    use TodosWeb, :controller
    plug Ueberauth
    alias TodosWeb.User

     def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        
        user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
        changeset = User.changeset(%User{}, user_params)

        signin(conn, changeset)
    end
    def signin(conn, changeset) do
        IO.puts("++++++++++++++++++++++++")
        IO.inspect(conn.assigns[:user])
        case insert_or_update_user(changeset) do
            {:ok, user} ->
                conn 
                |> put_flash(:info, "Welcome Back!")
                |> put_session(:user_id, user.id)
                |> redirect(to: Routes.task_path(conn, :index))
            {:error, _reason} ->
                conn
                |> put_flash(:error, "Error Signing in")
                |> redirect(to: Routes.task_path(conn, :index))
        end
    end

    def insert_or_update_user(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil -> 
                Repo.insert(changeset)
            user ->
                {:ok, user}
        end
    end

    def signout(conn, _params)  do
        conn
        |> configure_session(drop: true)
        |> redirect(to: Routes.task_path(conn, :index))
    end
end