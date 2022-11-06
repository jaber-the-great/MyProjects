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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        DataClasses1DataContext dbc = new DataClasses1DataContext();

        public static string IDvalue = "";
        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)//admin
        {
            if(textBox1.Text=="jaber" && Convert.ToInt16(textBox2.Text)==1234)
            {
                IDvalue = textBox1.Text;
                admin_login a =new admin_login();
               // a.ShowDialog();
                a.Show();
                Hide();
            }
            else
            {
                MessageBox.Show("username or password incorrect");

            }

        }

        private void button2_Click(object sender, EventArgs e)//staff
        {
            var ID = from o in dbc.staffs
                     where o.ID == textBox1.Text && o.pass == textBox2.Text
                     select o;
            IDvalue = textBox1.Text;
            if (ID.Count() == 1)
            {

                staff_log a = new staff_log();
               // a.ShowDialog();
                a.Show();
                Hide();

            }
            else
            {
                MessageBox.Show("username or password incorrect");
           
            }
        }

        private void button3_Click(object sender, EventArgs e)//doctor
        {
            var ID = from o in dbc.doctors
                     where o.ID == textBox1.Text && o.pass == textBox2.Text 
                     select o;
            IDvalue = textBox1.Text;
            if (ID.Count() == 1)
            {

                Doctor_login a = new Doctor_login();
              //  a.ShowDialog();
                a.Show();
                Hide();

            }
            else
            {
                MessageBox.Show("username or password incorrect");

            }
        }

        private void button4_Click(object sender, EventArgs e)//insured
        {
            var ID = from o in dbc.insureds
                     where o.ID == textBox1.Text && o.pass == textBox2.Text
                     select o;
            IDvalue = textBox1.Text;
            if (ID.Count() == 1)
            {

                insured_login a = new insured_login();
             //   a.ShowDialog();
                a.Show();
                Hide();

            }
            else
            {
                MessageBox.Show("username or password incorrect");

            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
