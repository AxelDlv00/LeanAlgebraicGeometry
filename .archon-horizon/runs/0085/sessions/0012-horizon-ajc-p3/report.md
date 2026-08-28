Nothing of mine is uncommitted. The checkpoint fired on my two memory-file writes, which live outside the ledger work tree.

All five paths I authored are byte-identical between HEAD and disk: `InvariantsLocalization.lean`, `GaloisQuotientGlue.lean`, the board row, and the I-1462 item plus its comment. The one uncommitted `.lean` under AJC (`PicEtGaloisAction.lean`, 299 lines) is **ajc-p4's**, committed by them at `35f072464b` and present at HEAD — it shows as untracked only because it is absent from the shared index, which is I-1462's hazard in its other direction, not a change of mine. My 47 probe files are all under `/tmp/ajcp3-probe/`, deliberately outside the work tree, since scratch dirs are not gitignored here (I-1384/I-1393).

The file-mutating tool calls after my last commit were the two memory files at `/home/axel/.claude-api/projects/…/memory/` — outside `/home/axel/LeanAlgebraicGeometry-Horizon`, so they produce no durable ledger change and are not committable.

## Progress

- `AlgebraicJacobian/Picard/GaloisDescent/InvariantsLocalization.lean` (new, rooted at `AlgebraicJacobian.lean:353`): 0 → 341 lines, **10 declarations, zero code sorries**, all ten axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` as a control that fires `sorryAx` in the same run, oleans rebuilt before the probe. `lake env lean` EXIT=0; module build EXIT=0.
  - `powers_map_eq` — `γ` carries `Submonoid.powers N` onto itself; the one place invariance is spent, and why mathlib cannot supply the action.
  - `awayAut` / `awayAut_algebraMap` / `awayAutHom` / `awayAction` — the transported automorphism and the Γ-action; both laws are `IsLocalization.ringHom_ext` against the value on the image of `A`.
  - `isSemilinear_away` — the payload: semilinearity is the hypothesis of `invariantsSubalgebra` / `descentAlgEquiv`, so Speiser reaches a localized chart with no new descent argument.
  - `isGaloisQuotient_away` — the localized chart has a Galois quotient, all three clauses; a citation, not a construction.
  - `powers_map` + `powers_map_eq_forces_pow` — non-vacuity of the invariance hypothesis **as a theorem**, not a failing `exact?`.
- `AlgebraicJacobian/Picard/GaloisQuotientGlue.lean`: +32 lines correcting its own layer-2 pricing at the site that set it.
- **Board**: `AJC.picrep.etale-rep.galois` advanced, owner cleared, pinned `95086a643c`, verified with `git show HEAD:`. Eight commits, `7a4ac3bd7c` through `95533abddd`.

**Which item and why third.** G2(c), the non-affine Galois quotient — the only repair input that *produces a scheme* rather than reasoning about classes given one, and the only one no lane held. p1/p2/p4 all hold statements that **bind** `IsGaloisQuotient`, so a producer is upstream of them; I contested nobody.

**State: advanced, not closed — the reason is applicability, not provability.** Layer 2's algebra half is closed sorry-free. `isGaloisQuotient_away` is a theorem **no site has been shown able to apply**: binders jointly satisfiable at a non-degenerate site (`A = L ⊗[K] K[X]`, `N = 1 ⊗ X`, invariant non-unit, five instances by `inferInstance`), yet the application fails synthesis on `IsSemilinear` with a hypothesis of that exact type in context. An instance-path mismatch that survived four fixes. Recorded in the corollary's docstring at HEAD.

## Issues

- **I-1461**: layer 2 was priced at two sites as `(A_N)^Γ = (A^Γ)_N`, whose left side presupposes an action that does not exist. The gating step was one level below the equality; and once the action exists the equality is not what layer 3 wants. Clause (c) of my corrected split is labelled a reading, not a measurement.
- **I-1463**: a sorry-free axiom-clean theorem can have no applicable site. This round sharpened non-vacuity twice (I-1413, I-1456) — both about whether hypotheses are real, neither about whether the theorem can be used.
- **I-1462**: index hazard with **zero** staged deletions and 23 deletion lines against a stale blob — the shape a `^D` grep misses. Re-measured at session end as 6 staged D and 250 deletion lines including 65 of another lane's AJCR proof file. Nothing lost; all verified at HEAD and on disk.
- Two background audits (sibling-engine pricing; adversarial audit of my file) did not report before session end, so **my file has no fresh-context review**. Every claim above I measured myself.

## Why I stopped

The item is advanced, not complete: layer 2's covering half, layer 3's `GlueData` and layer 4 are open, `HasGaloisQuotient` is still affine-only, and the Hironaka trap at layer 3 is untouched. I stopped on the applicability mismatch after four attempts failed identically — a Lean instance-resolution problem, recorded rather than left as a fifth half-finished tweak.

## Next

Layer 2's covering half (invariant basic opens cover a stable open inside a chart; `π_U(V)` open) — genuinely a covering fact, not algebra. Before consuming `isGaloisQuotient_away`, resolve the instance mismatch by pinning the action with an explicit `letI` at your own object. And check whether the `GlueData`'s **overlap isomorphisms** need the invariants equality after all; that is where my clause (c) could be wrong.
