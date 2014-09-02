package com.ddc.mem;

class CaseObject{

    private static int sleepTotalTime=0; 

 boolean execute(int sleepTime) throws Exception{
try{
        System.out.println("sleep: "+sleepTime);
        sleepTotalTime+=sleepTime;
        Thread.sleep(sleepTime);
display();
        if(sleepTime%2==0)
            return true;
        else 
            return false;
    }finally
{
}
}
private void display(){
System.out.println("display");
}
}
