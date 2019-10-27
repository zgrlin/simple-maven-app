public class ProcStart {
	public static void main(String[] args) {
		Process fork = new Process();
		fork.setprocId(1);
		System.out.println("Process id is= "+fork.getprocId());
	}
}
