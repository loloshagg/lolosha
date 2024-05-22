
    private string connectParams = "datasource=127.0.0.1;port=3306;username=root;password=;database=BobrDrive2;";
    private MySqlConnection connection;

    public Db()
    {
        connection = new MySqlConnection(connectParams);
    }

    public int CountRecords(string query)
    {
        if (connection.State != ConnectionState.Open) connection.Open();
        MySqlCommand command = new MySqlCommand(query, connection);
        MySqlDataReader reader = command.ExecuteReader();
        int counter = 0;
        while (reader.Read()) counter++;
        connection.Close();
        return counter;
    }

    public void InsertRecord(string query)
    {
        if (connection.State != ConnectionState.Open) connection.Open();
        MySqlCommand command = new MySqlCommand(query, connection);
        command.ExecuteNonQuery();
        connection.Close();
    }

    public DataRow getSignleRecord(string query)
    {
        if (connection.State != ConnectionState.Open) connection.Open();
        MySqlCommand command = new MySqlCommand(query, connection);
        MySqlDataAdapter adapter = new MySqlDataAdapter(command);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        connection.Close();
        return ds.Tables[0].Rows[0];
        // https://metanit.com/sharp/adonet/3.6.php
    }

    public DataTable getRecords(string query)
    {
        if (connection.State != ConnectionState.Open) connection.Open();
        MySqlCommand command = new MySqlCommand(query, connection);
        MySqlDataAdapter adapter = new MySqlDataAdapter(command);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        connection.Close();
        return ds.Tables[0];
    }
}


 private void authButton_Click(object sender, EventArgs e)
 {
     string query = $"SELECT * FROM Employees WHERE " +
         $"`login` = '{login}' AND `password` = '{password}'";

     if (db.CountRecords(query) > 0)
     {
         var row = db.getSignleRecord(query);
         AppState.create((string)row["phone"], (int)row["positionId"]);

         switch (AppState.get().position)
         {
             case 1: // admin
                 new AdminDispatchers().Show();
                 Hide();
                 break;
             case 2: // dispatcher
                 new DispatcherOrders().Show();
                 Hide();
                 break;
             case 3: // driver
                 new DriverShiftStart().Show();
                 Hide();
                 break;
         }
     }
 }


  private void addButton_Click(object sender, EventArgs e)
  {
      var name = addNameTextbox.Text;
      var price = addPriceTextbox.Text;
      var description = addDescriptionTextbox.Text;

      string query = $"INSERT INTO Product (" +
          $"name, price, description" +
          $") VALUES (" +
          $"'{name}', {price}, '{description}')";

      try
      {
          db.InsertRecord(query);
      }
      catch
      {
          MessageBox.Show("Ошибка добавления товара");
      }

      addNameTextbox.Text = "";
      addPriceTextbox.Text = "";
      addDescriptionTextbox.Text = "";

      refreshProductsList();
  }
