using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DbFinal
{
    public partial class a_staff : Form
    {
        public a_staff()
        {
            InitializeComponent();
        }

        DataClasses1DataContext dbas = new DataClasses1DataContext();
        private void get_data()
        {
            dataGridView1.DataSource = dbas.staffs.ToList();

        }
        private void button1_Click(object sender, EventArgs e)//c
        {
            staff temp = new staff();
            temp.ID = textBox1.Text;
            temp.Staff_ID = textBox2.Text;
            temp.pass = textBox3.Text;
            temp.hire_day = Convert.ToDateTime(textBox4.Text);
            temp.salary = int.Parse(textBox5.Text);
            temp.position = textBox6.Text;
            temp.branch_code = textBox7.Text;
            dbas.staffs.InsertOnSubmit(temp);
            dbas.SubmitChanges();
            get_data();
            
        }

        private void button2_Click(object sender, EventArgs e)//r
        {
            get_data();
        }

        private void button4_Click(object sender, EventArgs e)//u
        {
            staff temp = dbas.staffs.FirstOrDefault(x => x.ID == textBox1.Text);
                if(textBox2.Text != String.Empty)
                     temp.Staff_ID = textBox2.Text;
                if(textBox3.Text != String.Empty)
                    temp.pass = textBox3.Text;
                    if(textBox4.Text != String.Empty)
                        temp.hire_day = Convert.ToDateTime(textBox4.Text);
                        if(textBox5.Text != String.Empty)
                            temp.salary = int.Parse(textBox5.Text);
                            if(textBox6.Text != String.Empty)
                                temp.position = textBox6.Text;
                                if(textBox7.Text != String.Empty)
                                    temp.branch_code = textBox7.Text;
                                
                                get_data();
        }

        private void button3_Click(object sender, EventArgs e)//d
        {
            staff temp = dbas.staffs.FirstOrDefault(x => x.ID == textBox1.Text);
            dbas.staffs.DeleteOnSubmit(temp);
            dbas.SubmitChanges();
            get_data();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label7_Click(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)//search
        {
            var q = from o in dbas.staffs
                    join p in dbas.users on o.ID equals p.ID
                    where o.ID == textBox1.Text || o.Staff_ID==textBox2.Text
                    select new
                    {
                        first_name = p.first_name,
                        last_name = p.last_name,
                        position = o.position,
                        salary = o.salary,
                        phone = p.phone
                    };
            dataGridView1.DataSource = q;
            //dataGridView1.DataBindings();  

        }

        private void a_staff_Load(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {
            admin_login a = new admin_login();
            a.Show();
            Hide();
        }
    }
}
