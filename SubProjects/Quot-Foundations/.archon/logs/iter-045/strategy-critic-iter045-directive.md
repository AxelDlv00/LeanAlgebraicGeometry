# Strategy-critic directive — iter-045

Fresh-eyes audit of the project strategy. Read ONLY:
- `/home/archon/proj/Quot-Foundations/.archon/STRATEGY.md` (verbatim — the strategy under review).
- `/home/archon/proj/Quot-Foundations/references/summary.md` (reference index).
- Blueprint chapter titles (below).

Do NOT read: iter sidecars, PROGRESS.md, task_pending/task_done, task_results, review reports. Judge the
strategy as a fresh mathematician would — not invested in existing momentum.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the Čech-independent leg of Kleiman's FGA Picard-scheme representability
cone: (FBC) the i=0 flat-base-change map `g* f_* F ⟶ f'_* g'* F` is an iso; (GF) generic flatness
`genericFlatness` from its algebraic core; (QUOT) Hilbert polynomial / Quot functor / Grassmannian scheme +
representability. End-state: zero project sorry in the closure, zero project axioms, kernel-only axioms.

## Blueprint chapters
- Cohomology_FlatBaseChange — flat base change for pushforward of a qcoh sheaf (i=0)
- Cohomology_RegroupHelper — regrouping iso for the affine base-change tensor tower
- Picard_FlatteningStratification — flattening stratification / generic flatness
- Picard_GrassmannianCells — the Grassmannian over ℤ
- Picard_QuotScheme — the Quot scheme (Hilbert poly, predicates, qcoh affine-local descent)
- Picard_RelativeSpec — relative Spec

## What changed this iter (for your re-verification, not as justification)
gap1+gap2 (QUOT qcoh affine-local descent) are now CLOSED → GF-geo moved BLOCKED→ACTIVE (G1 this iter); the
QUOT-defs row shrank to annihilator-char + P2. FBC-A1 keystone `_legs_conj` is recorded STUCK (8-iter wall)
with an armed kill-criterion: iter-045 is the FINAL in-loop round, else escalate+park.

Challenge anything unsound: is the FBC "one final round then park" the right disposition, or should FBC park
now? Is the GF/QUOT/FBC phase ordering and the import-over-extraction choice (GF-G1 imports QuotScheme) sound?
Are any phases mis-estimated or mis-sequenced?
