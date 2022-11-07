public class Students
    {
        private String firstName;
        private String lastName;
        private int stdNumber;
        private boolean flag;

        public Students(String first, String last, int std)
            {
                this.firstName=first;
                this.lastName=last;
                this.stdNumber=std;
                this.flag=false;
            }

        public int getStdNumber()
            {
                return stdNumber;
            }

        public String getFirstName()
            {
                return firstName;
            }

        public String getLastName()
            {
                return lastName;
            }

        public boolean isFlag()
            {
                return flag;
            }

        public void setFirstName(String firstName)
            {
                this.firstName = firstName;
            }

        public void setLastName(String lastName)
            {
                this.lastName = lastName;
            }

        public void setStdNumber(int stdNumber)
            {
                this.stdNumber = stdNumber;
            }

        public void setFlag(boolean flag)
            {
                this.flag = flag;
            }

        public int find(Students[] stds ,int std)
            {
                for(int i=0;i <stds.length; i++)
                    {
                        if(stds[i].getStdNumber() ==std )
                            return i;
                    }
                return -1;

            }

        @Override
        public String toString()
            {
                return String.format("%s, %s, %d, %b",getFirstName(),getLastName(),getStdNumber(),isFlag());
            }
    }
