Every path I authored — Lean, board, and inbox — matches HEAD exactly. Nothing uncommitted.

## Progress

- `Picard/PicEtDescentRepresentability.lean`: **new**, 24 declarations, 0 code sorries, rooted at `AlgebraicJacobian.lean`. All 24 axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` firing `sorryAx` in the same probe file. `lake build AlgebraicJacobian` EXIT=0 (8882 jobs); the one warning is a pre-existing long comment at `AlgebraicJacobian.lean:335`, not mine.
- `AlgebraicJacobian.lean`: +1 import, rooting the module.
- Board + inbox: row summary/owner/pins, two board comments, four inbox items (I-1446 claim, I-1458 and I-1476 findings, I-1475 release) — all committed and verified at HEAD.

**Which item and why second.** `AJC.picrep.etale-rep.descent-assembly`, unowned. Its own summary plus two other sites recorded that the theorem the other three lanes' items are antecedents *of* did not exist. p1 held invariance, p3 G2(c), p4 the Hom side — all inputs. Writing the consumer is what tells those lanes whether their outputs compose, which ranked above another leaf.

**State: closed as an implication, every antecedent named and open.** `representableBy_of_coverCompatibleEquiv` takes a `k`-scheme whose points are naturally the cover-compatible `picEt C`-classes on `T_{k'}` and concludes `(picEt C).RepresentableBy Y` — data over the cover, conclusion over `k`, with no `picEt C` representation in any hypothesis. The seam `sorry` is untouched and **no antecedent of `fgaPicardRepresentability` is witnessed for any curve**: `Y`, the `Equiv` family and `hcov` are all hypotheses.

**What changes another lane's plan.** `coverMap` *is* the counit of `Over.map ⊣ Over.pullback`, so the cover is mathlib's and its naturality is free. `hcov` carries no étale-site obligation — any open cover's sieve is an étale covering sieve in one line — and its residue is exactly two geometric facts about `(coverSelfSection T γ).left`, open immersion *and* joint surjectivity, after which `hcov` closes with one `rw`. Filed as I-1458, hinted to p1 and p4.

## Issues

Four of my published claims were refuted and corrected in-tree, each reproduced before I edited:

- **"those binders are consumed at exactly ONE place"** — false (I-1470). `FiniteDimensional k k'` *is* `Module.Finite k k'` by `rfl`, and `selfTensorSpecCoproduct` binds it load-bearingly: a second site on the route my own paragraph priced. The alias spelling is why a name-level grep missed it.
- **"hcov satisfiable, hence not vacuous"** — a non-sequitur inherited from p1's file (I-1454). `Mono` forces every `γ` to be the identity, so the only exhibited model trivialises the consequent.
- **the `hcov` split named one of two owed facts** (I-1473).
- **the assembly's coordinates are generic** (I-1471) — both theorems re-derive with `Scheme`, `Field`, `picEt`, cover and descent all deleted. The geometry is entirely in the input `restrictCompatEquiv`; budget the assembly as missing plumbing, not a theorem about curves.

I also pinned another lane's HEAD by using `rev-parse` at release, and corrected it visibly rather than dropping it.

Live hazard recorded not fixed (I-1476): at close the shared index stages 658 deletions behind only 8 staged `D`, and six of those are files my own boundary-pass commit created seconds earlier — including I-1476's own item. All verified present at HEAD and on disk.

## Why I stopped

Partly advanced. The row's goal now exists sorry-free, but it is an implication with three open antecedents, and the converse I proved makes it a change of coordinates rather than a discount on the seam. One commit hit a ref-lock failure and did not land; the post-commit check caught it and I re-seeded.

## Next

`hcov` at a nontrivial Galois level, now reduced to two named scheme-level facts. Higher value if a reviewer takes it: I-1416 is still unacted — pricing Hilb against the Grassmannian, where both routes may bottom out in the same unformalised "smooth proper curve is projective" node.
