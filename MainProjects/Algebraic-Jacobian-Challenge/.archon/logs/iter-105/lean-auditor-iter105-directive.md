# Lean Auditor Directive

## Slug
iter105

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — heavily edited this iter; new `have h_iter104` staged at L1119 inside `cechCofaceMap_pi_smul`; surrounding comment block describes a partial proof scaffold.
- `AlgebraicJacobian/Differentials.lean` — large dead-code block at L675-L912 was reported by iter-104 lean-auditor as a major finding; verify whether iter-105 refactor cleaned it up.
- `AlgebraicJacobian/Picard/LineBundle.lean` — iter-104 lean-auditor flagged a critical "admitted-wrong" definition `LineBundle X := CommRing.Pic Γ(X, ⊤)`. Re-audit and confirm whether the docstrings still acknowledge this, and whether the wrongness is still contained.

## Known issues
- L1120 sorry inside `cechCofaceMap_pi_smul` is the active prover-target this iter (partial scaffold at L1115-L1119, sorry at L1120). Do not flag the sorry itself as a defect — flag only the surrounding comment block if it functions as an excuse-comment.
- Iter-104 lean-auditor already flagged 4 stale "Body left as 'sorry' for iter-XXX prover" docstrings at L488, L760, L823, L871. Verify whether iter-105 plan-phase prose pass addressed any of them; if so, drop them; if not, re-flag.
- L1212/L1536/L1564/L1754/L1783 (BasicOpenCech) and L122/L636/L957/L974/L1116 (Differentials) sorries are long-standing deferred sites, not iter-107 targets — do not flag the sorry itself; flag only if a stale comment misrepresents the status.
