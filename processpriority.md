1.  03_ec2.tf 에 102~155줄 주석 , 04_load.tf 에서 44~51 ,96~103  주석처리
 05_auto.tf 전체 다 주석
저장
terrafrom apply 
{이유: nlb의 dns를 web인스턴스 proxy에 기입해야해서}

2. nlb 엔드포인트 proxy에 기입  (http://dns/) 이렇게 넣어야됨
   03_ec2.tf 주석 전체 해제
저장
terrafrom apply 
petclinic 뜰때까지 대기
{이유: was의  petclinic배포한 ami를 terraform이 배포되기전에 ami를 따서 was를 다 만든 후 ami 따기}


3. 05_auto.tf 전체 주석해제 , 04_load.tf 전체 주석 해제
저장
terrafrom apply
{이유: 2번의 이유와 같다} 