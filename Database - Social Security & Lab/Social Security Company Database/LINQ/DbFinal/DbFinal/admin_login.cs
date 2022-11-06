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
    public partial class admin_login : Form
    {
        public admin_login()
        {
            InitializeComponent();
        }


        DataClasses1DataContext db = new DataClasses1DataContext();

        private void admin_login_Load(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)//staff
        {
            a_staff a = new a_staff();
            a.Show();
            Hide();
        }

        private void button3_Click(object sender, EventArgs e)//doctor
        {
            a_doctor a = new a_doctor();
            a.Show();
            Hide();
        }

        private void button2_Click(object sender, EventArgs e)//insured
        {
            a_insured a = new a_insured();
            a.Show();
            Hide();
        }

        private void button1_Click(object sender, EventArgs e)//users
        {
            a_users a = new a_users();
            a.Show();
            Hide();
        }

        private void button5_Click(object sender, EventArgs e)//med_station
        {
            a_med a = new a_med();
            a.Show();
            Hide();
        }

        private void button6_Click(object sender, EventArgs e)//branch
        {
            a_branch a = new a_branch();
            a.Show();
            Hide();
        }

        private void button8_Click(object sender, EventArgs e)//go back
        {
            Form1 a = new Form1();
            a.Show();
            Hide();
        }

        private void button7_Click(object sender, EventArgs e)//address
        {
            a_address a=new a_address();
            a.Show();
            Hide();
            
        }

    }
}
