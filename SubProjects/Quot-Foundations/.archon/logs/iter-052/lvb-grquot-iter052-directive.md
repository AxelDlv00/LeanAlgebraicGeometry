# lean-vs-blueprint-checker — GrassmannianQuot (iter-052)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

Verify bidirectionally:
- pullbackBaseChangeTransport ↔ lem:modules_pullback_basechange_transport: signature match?
- glue: a well-typed _hC2 cocycle hypothesis was added this iter (def:scheme_modules_glue C2). Does the blueprint C2 statement match the Lean hypothesis? Body still sorry (planner-deferred) — is that honest?
- NEW unblueprinted helpers: glueData_bridge_src/mid/tgt (triple-overlap endpoint bridges) have NO blueprint block. Flag as coverage debt.
- Are the 5 scaffold sorries (glue, universalQuotient, tautologicalQuotient, functor, represents) honestly documented?
Report both directions. Mark must-fix-this-iter findings.
