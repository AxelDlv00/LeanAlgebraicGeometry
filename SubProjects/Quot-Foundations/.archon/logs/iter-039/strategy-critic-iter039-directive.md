# Strategy critic — iter-039

Fresh-mathematician audit of the project strategy. Read ONLY these inputs (do NOT read PROGRESS.md,
task_pending/done, iter sidecars, or recent prover/review narrative — your value is the uninvested view):

- `.archon/STRATEGY.md` (verbatim — read it).
- `references/summary.md` (the reference index — read it).
- Blueprint chapter titles (one-line topics) below.
- The project goal (below).

## Project goal

Close the `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): FBC (i=0 flat base change of
`f_* F`), GF (generic flatness), QUOT (Hilbert polynomial, Quot functor, Grassmannian scheme +
representability). End-state: zero project `sorry` in the closure, kernel-only axioms; names/labels are
the parent's so finished work merges back.

## Blueprint chapters (title — topic)

- `Cohomology_FlatBaseChange.tex` — Flat base change for the pushforward of a quasi-coherent sheaf (i=0).
- `Cohomology_RegroupHelper.tex` — Regrouping iso for the affine base-change tensor tower.
- `Picard_FlatteningStratification.tex` — Flattening stratification of a coherent sheaf (generic flatness).
- `Picard_GrassmannianCells.tex` — The Grassmannian over ℤ (charts, cocycle, glue, separated, proper).
- `Picard_QuotScheme.tex` — The Quot scheme (Hilbert polynomial, predicates, gap1 affine descent).
- `Picard_RelativeSpec.tex` — Relative Spec.

## What changed since your iter-038 review

- **GR-proper phase COMPLETED** (`Gr(d,r)` proper over ℤ, axiom-clean — `isProper`/`lem:gr_proper`
  landed iter-038). Its row moves to `## Completed`.
- **FBC route** remains KEEP (your iter-038 CHALLENGE was "execute the re-cut, don't re-consult"; the
  in-iter mathlib-analogist established no re-cut is owed — the proof-free conjugate read is already
  built — so the actionable residual is the `_legs_conj` PROOF, dispatched as a prover round THIS iter).
- **QUOT gap1** continues: all Hfr ingredients now DONE; this iter assembles the keystone descent.

## Your questions

1. Is the post-GR-proper strategy table sound — are the remaining active phases (FBC-A1/A2, FBC-B,
   GF-geo, QUOT-defs gap1, SNAP, QUOT-repr) correctly ordered and scoped, given GR-proper is now done?
2. Is the FBC KEEP decision still defensible from a fresh view, or does the 5-iter stall on the mate
   coherence signal a genuine structural dead-end that a re-cut/pivot would escape? (You challenged the
   process last iter; re-assess the SUBSTANCE now that the prover round is being executed.)
3. Any unsound case-split, hallucinated route, or missing prerequisite in the QUOT gap1 → GF-geo
   dependency, or in the SNAP/QUOT-repr deferrals?

Read-only. Write your report to `task_results/strategy-critic-iter039.md`.
