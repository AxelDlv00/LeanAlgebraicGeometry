# review-ajcr (run 0082) probe files

Read-only measurements behind the reviewer's re-ranking of the three antecedents of
`pic0RepresentableByOfCharts` (Picard/Pic0SigmaSheaf.lean:161). Each was run with
`lake env lean <file>` from the project root, EXIT=0. None was added to the project.

- `ajcr_probe3.lean` — `pic0RepresentableByOfCharts` ELABORATES at `iota = PEmpty` with
  `hf := fun i => PEmpty.elim i`: no charts, no `rep`, no `IsChartUniv`. So antecedent 1
  at a free `V` carries no content.
- `ajcr_probe5.lean` — at `iota = PEmpty` the supremum image sieve is `bottom`.
- `ajcr_probe6.lean` — the `bottom` sieve is Zariski-covering only for an EMPTY test
  (`False` derived from a point of the test). This is what makes probe3 harmless rather
  than a vacuity of the seam: all the content forcing the atlas to be an atlas sits in
  the local-surjectivity instance, i.e. antecedent 2.
- `ajcr_probe7.lean` — no nonempty test scheme has a point of the empty open subscheme,
  so `IsChartUniv` at `V = bottom` has free injectivity.

  **QUALIFIED by ajcr-p1 (I-0890), and the qualification is correct — read it before
  reusing probe7.** "Free at `V = bottom`" is true of the INJECTIVITY clause and of
  `exists_factor`, and FALSE of the fibre datum as a whole: the `sq` field at an empty
  test asks two values of `pic0SigmaFunctor C` to agree, which reduces to
  `Subsingleton (pic0Subgroup C (Over.mk a))` over an empty base — true mathematically,
  a separate lemma, and absent from the tree. So the degenerate value shows the clause
  is cheap; it does NOT exhibit an inhabitant of the datum. `cheap` and `satisfiable`
  come apart here. This does not affect the probe3/5/6 conclusion (that antecedent 2
  carries the content), which never used `V = bottom`.

A fifth probe (not kept here) reproduced ajcr-p1's finding that `IsChartLocusFibre`
implies `IsOpenImmersion.presheaf` of the UNRESTRICTED Abel chart. That lane has since
landed it as rooted theorems in Picard/Pic0ChartLocusFibreGuard.lean, so the probe is
superseded by real project code.
