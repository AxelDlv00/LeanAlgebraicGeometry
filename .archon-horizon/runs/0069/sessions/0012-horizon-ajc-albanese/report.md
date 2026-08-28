Nothing uncommitted. The checkpoint was triggered by post-commit file mutations that produced no durable ledger change: three scratch-probe **deletions** (`bare_stable_cover.lean`, `probe_albanese_tensor.lean`, `probe_albanese_under.lean` — the first was untracked in the ledger after `0eca760dd` removed it, the other two never tracked), and two writes to my agent memory directory outside the repo. Every authored Lean file and both probe scripts are in HEAD byte-identical to disk, and the index is defused for my paths.

## Summary

The Albanese leg's residue is one object — `Sym^g C` — and this round found that the two hardest-looking pieces of it were **not missing but misfiled**. Milne's affine carrier `(A^{⊗n})^{S_n}` was *unstateable* rather than unproved, and the `G`-stable affine cover its gluing needs already existed in the project under a Galois statement whose proof never touches semilinearity. Three sorry-free files, six commits, all axiom-clean against firing controls.

A fresh-context review then retracted my headline residue count and found a landed lemma that was true but unusable. Both are fixed, and the retraction is the more useful half of this report.

## Progress

- `Albanese/SymPowTensorAction.lean` (new, 0 sorries): `permAlgHom` — factor permutation of `⨂[R] i, A` as an **algebra** hom, via `liftAlgHom` on the `domDomCongr`'d `tprod`. Mathlib has it only as a *linear* equiv (`PiTensorProduct.reindex`, no `reindexAlgEquiv`), so `MulSemiringAction (Equiv.Perm ι)` did not synthesize and `FixedPoints.subring` — which requires it — could not be applied: Milne's carrier could not be *written down*. Plus `permMulSemiringAction` (σ acts as `permAlgHom σ⁻¹`, since `permAlgHom` is an **anti**-homomorphism), `permSMulCommClass`, `symTensorPowSubalgebra`. Characteristic-free — nothing averages, so no `g!` is inverted, which is what makes it usable at `char k̄ ≤ g`.
- `Albanese/SymPowInvariantsUnder.lean` (new, 0 sorries): the invariants **are** the limit in `Under k`, dually a colimit in `(Under k)ᵒᵖ` — the consumer's category and variance. Cheaper by *restating* than by transporting across `Over.opEquivOpUnder`: `FixedPoints.subalgebra` is already a `k`-algebra, so the proof is the `CommRingCat` one with `(Under.forget k).map_injective` before each `hom_ext`. Closes the third item `SymPowInvariants` §4 listed as open.
- `Albanese/StableAffineCoverGroup.lean` (new, 0 sorries): every point has a `G`-stable affine open neighbourhood, for a **bare** finite group acting by automorphisms. Not new mathematics — the same proof as `Picard/StableAffineCover.lean:193`, whose `SemilinearGalAction` binder its body never uses (`compat` never appears; `FiniteDimensional` buys only a `Fintype`). Confirmed by porting the body verbatim with the binder replaced.
- `AlgebraicJacobian.lean`: five import lines. Four sorry-free `SymPow*` modules sat outside the root cone, so `lake build AlgebraicJacobian` never elaborated them and my own "8563 jobs exit 0" did not cover the files I shipped.
- `scripts/albanese-symmetric-axioms.lean`, `scripts/albanese-universe-check.lean` (new): root-seeded axiom probe and a universe regression test.
- `AlbaneseUP.lean`: **6 sorries, unchanged.** Stated against a `sorry`-bodied `SymmetricPower`, so discharging them would establish nothing.

## Issues

**My residue count was wrong, and the missed item is the blocking one.** I published "the gluing is three inputs, one closed". It is four: `symPowData_affineAlgebra` builds its diagram from the *n*-ary **coproduct** of algebras in `Under k`, while everything I proved is about `PiTensorProduct`. Identifying them needs the *n*-ary coproduct/tensor-power comparison — mathlib has only the **binary** case, AJC nothing. So this round fixed the previous round's *category* mismatch and reproduced the same shape one level down at the *object*. Retracted on the team thread.

**A lemma that was true and inapplicable.** `hasColimit_singleObj_of_op` landed with all universes pinned to `u`, excluding `Under k` (`Category.{u, u+1}`) — the one category the leg needs, and the one my §5 claimed it served. Generalized to `{C : Type w} [Category.{v} C]`, same proof, with a regression test instantiating it at `Under k` and `(Under k)ᵒᵖ`.

**A second phantom declaration, in a file whose header a previous reviewer already fixed for exactly this.** `StableAffineCoverGroup` advertised `permAction`, an `S_n` action into `Aut`. It does not exist and is not free: `MonObj.permAut` is never shown invertible, `permEnd` lands in `End`. It was the only item connecting my theorem to `S_n`, so the scope claim went with it — right hypotheses, no producer.

**Environmental:** the shared mathlib checkout was re-cloned mid-session (source and oleans gone across all seven projects); it recovered unaided at the pinned rev, and I posted both the alert and the retraction of my "run `cache get`" advice. The shared ledger index armed the I-0611 stale-deletion hazard after every commit; I defused my paths each time, but one scratch probe was swept into another lane's commit first — removed in `0eca760dd`. Two CLI hazards: agent comments cap at 1200 chars (six rejections), and `task comment` exits 0 while `task show --json` reports no comments — mine did land, verified on disk as `C-0006`.

Janitor pass (dispatched, waited on) found three things I had wrong, including that my root-cone claim was untrue; all reconciled above.

## Why I stopped

**Partly advanced, not complete.** `AlbaneseUP.lean`'s six sorries stand and `albanese_universal_property` still reports `sorryAx` — measured, with all three controls firing. Task left non-terminal so it returns to the queue.

Verification: my modules `lake build` → 8569 jobs, exit 0, zero warnings; probe 16 clean readings, three firing controls. The **full root build failed** at 8813/8815 in `Picard/RigidPushforwardTransfer.lean` with `no such file or directory` — another lane's file hitting an olean race under 8-lane contention, not a Lean error. My reviewer independently got 8815 jobs exit 0; that is their measurement, not mine, and I did not re-run it.

## Next

**Not the gluing.** Two cheap bricks, both prerequisites to any consumer of this layer: (i) the *n*-ary coproduct-of-algebras ≅ *n*-fold tensor power comparison with its permutation action matched to `permAlgHom` (mathlib's binary case: `Algebra/Category/Ring/Constructions.lean`); (ii) an `Equiv.Perm (Fin n) →* Aut (C^n)`, needing `MonObj.permAut` shown invertible. Only then do the four gluing items reduce to the two genuinely geometric ones: overlap cocycles, and `OrbitsInAffineOpen` for the curve — where quasi-projectivity enters, and mathlib has no such vocabulary at this pin. Zero consumers of this layer is now three rounds deep; worth treating as the signal it is rather than adding a fourth.
