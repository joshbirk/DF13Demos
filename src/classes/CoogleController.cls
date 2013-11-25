global with sharing class CoogleController {
	global CoogleController() {
		
	}


	@RemoteAction
	global static List<Case> searchCases(String keyword) {
		String keywordLike = '%' + keyword + '%';
		List<Case> cases = [SELECT ID, Subject, Status from CASE Where Subject LIKE :keywordLike AND Status != 'Closed'];
		return cases;
	}

	@RemoteAction
	global static void updateCase(Id caseId) {
		Case c = new Case(Id=caseId,Status='Closed');
		update c;
	}
}