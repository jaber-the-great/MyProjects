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
    public partial class a_branch : Form
    {
        public a_branch()
        {
            InitializeComponent();
        }

        DataClasses1DataContext dbab = new DataClasses1DataContext();
        private void get_data()
        {
            dataGridView1.DataSource = dbab.branches.ToList();
        }
        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)//c
        {
            branch temp = new branch();
            temp.branch_code = textBox1.Text;
            temp.postal_code = int.Parse(textBox2.Text);
            temp.province = textBox3.Text;
            temp.city = textBox4.Text;
            temp.street = textBox5.Text;
            temp.alley = textBox6.Text;
            temp.pelak = textBox7.Text;
            temp.phone =int.Parse(textBox8.Text);
            dbab.branches.InsertOnSubmit(temp);
            dbab.SubmitChanges();
            get_data();

        }

        private void button2_Click(object sender, EventArgs e)//r
        {
            get_data();
        }

        private void button4_Click(object sender, EventArgs e)//u
        {
            branch temp = dbab.branches.FirstOrDefault(x => x.branch_code == textBox1.Text);
            if(textBox1.Text!=string.Empty)
                temp.branch_code = textBox1.Text;
                if(textBox2.Text!=string.Empty)
                    temp.postal_code = int.Parse(textBox2.Text);
                    if(textBox3.Text!=string.Empty)
                        temp.province = textBox3.Text;
                        if(textBox4.Text!=string.Empty)
                            temp.city = textBox4.Text;
                            if(textBox5.Text!=string.Empty)
                                temp.street = textBox5.Text;
                                if(textBox6.Text!=string.Empty)
                                     temp.alley = textBox6.Text;
                                    if(textBox7.Text!=string.Empty)
                                        temp.pelak = textBox7.Text;
                                        if(textBox8.Text!=string.Empty)
                                            temp.phone = int.Parse(textBox8.Text);
                                       
                                        get_data();

           
        }

        private void button3_Click(object sender, EventArgs e)//d
        {
            branch temp = dbab.branches.FirstOrDefault(x => x.branch_code == textBox1.Text);
            dbab.branches.DeleteOnSubmit(temp);
            dbab.SubmitChanges();
            get_data();
        }

        private void button5_Click(object sender, EventArgs e)//s
        {
            var q = from o in dbab.branches
                    where o.branch_code == textBox1.Text || o.city == textBox4.Text
                    select new
                    {
                        branch_code = o.branch_code,
                        province = o.province,
                        city = o.city,
                        street = o.street,
                        pelak = o.pelak,
                        postal_code = o.postal_code,
                        phone = o.phone
                    };
            dataGridView1.DataSource = q;
          //  dataGridView1.DataBindings();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void a_branch_Load(object sender, EventArgs e)
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
