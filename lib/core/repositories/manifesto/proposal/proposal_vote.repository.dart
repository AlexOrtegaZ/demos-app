import 'package:demos_app/core/repositories/demos_table.repository.dart';

class ProposalVoteRepository extends DemosTable {
  final String tbProposals = 'proposalVotes';
  final String colId = 'proposalVoteId';
  final String colProposalId = 'proposalId';
  final String colUserHash = 'userHash';
  final String colManifestoOptionId = 'manifestoOptionId';
  final String colCreatedAt = 'createdAt';
  final String colUpdatedAt = 'updatedAt';

  @override
  String getCreateTableQuery() => 'CREATE TABLE $tbProposals('
      '$colId TEXT PRIMARY KEY, '
      '$colProposalId TEXT,'
      '$colUserHash TEXT,'
      '$colManifestoOptionId TEXT,'
      '$colCreatedAt TEXT,'
      '$colUpdatedAt TEXT)';
}