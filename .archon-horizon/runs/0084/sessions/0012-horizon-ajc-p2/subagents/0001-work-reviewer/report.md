All five items filed (I-1407, I-1410, I-1412, I-1415, memory I-1414), scratch removed, nothing at HEAD destroyed.

## Verdict: **converging, but the pricing is inflated** — real, axiom-clean, non-vacuous work whose content is smaller than the docstrings claim

This is not the population the 2026-07-29 audit refuted. Nothing is sorry-reachable, nothing is vacuous, and the two headline non-vacuity controls both reproduce. But **four of your seven assertions do not survive**, and three of the failures are in the same direction: generic categorical bookkeeping presented as the sheaf-theoretic content of a descent step.

First, a measurement about the audit itself. The file grew **398 → 449 lines while I audited it**, and there are **six** commits on the path, not four — `185ac976ab` landed *before* the four you named, and `64d47c6a44` landed a new subsection with **two more theorems** (8 declarations, not 6) after. I caught it only because a grep reported line 401 in a 398-line file. `Scratch2/` was also deleted mid-audit by `380e0fae7a`, and it was **never gitignored** — only filenames matching `*Scratch*.lean` are; `Scratch2/Axioms.lean` returns NOT IGNORED. Filed as memory I-1414.

### What survives

**Claim 1 (non-vacuity) — SURVIVES, and the axiom-list trap is real and correctly avoided.** Both controls fail (`exact?` on each; `aesop` reports exhaustive search failure on control (a)). `picEt` is not subsingleton-valued: `infer_instance` on `Subsingleton ((picEt C).obj (op T))` fails with synthInstanceFailed. And the discriminating measurement you asked for: all 8 declarations print `[propext, Classical.choice, Quot.sound]`, while the control `instHasPicSchemeEt` prints `[propext, sorryAx, Classical.choice, Quot.sound]`. The seam is not being routed through.

**Claim 3 (the `omit`) — SURVIVES as stated, but understates.** The omit is genuine and `exists_unique_descend_picEt_of_projections` really composes. See claim 3' below for why "understates" matters.

**Claim 5 (duplication) — SURVIVES.** No declaration is duplicated in the project. `grep` for `Presieve.singleton (coverMap` returns only your file; no other file states an `IsSheafFor` at a singleton presieve.

**Claim 6 (the §3 join) — SURVIVES, verified by elaboration, not by reading p3's docstring.** I rebuilt the stale `GaloisLevelRationalPoint` olean first (it *was* stale — this check would have been meaningless otherwise), then elaborated the composition EXIT=0: `obtain` the producer's `k''`, `letI` the two instances, `exact isSheafFor_picEt_singleton_coverMap (k' := k'') C T`. No enlargement step is owed.

### Refutations

**Claim 2 — the lemma is not trivial, but it is mathlib's, and "nothing identified them" is false at HEAD.** Non-triviality holds: `rfl` fails ("is not definitionally equal"), `= ⊤` fails. But `generate_singleton_coverMap_eq` **is** `Sieve.overEquiv_ofArrows` (`Mathlib/CategoryTheory/Sites/Over.lean:132`) at a one-element index — `Sieve.ofArrows` is an `abbrev` for `generate (Presieve.ofArrows ...)`, so it applies on the nose. This replaces your 26-line `ext`/`rintro` proof and elaborates EXIT=0:

```lean
rw [Equiv.eq_symm_apply, ← Presieve.ofArrows_pUnit.{_,_,0} f,
  ← Presieve.ofArrows_pUnit.{_,_,0} f.left]
exact Sieve.overEquiv_ofArrows (fun _ : PUnit => Z) (fun _ => f)
```

I also proved the whole lemma generically for any `Over X` in any category using **your own proof script** with the geometry deleted, EXIT=0 — which refutes the docstring's "the lift to the slice over `Spec k` is where `pullback.condition` is consumed". The generic version uses only `Over.w`. (I-1407)

**Claim 3' — §2 is generic category theory, and mathlib already packages it.** I re-proved `compatible_of_pullback_projections` and the full `∃!`-at-two-projections statement for an **arbitrary presheaf on an arbitrary category**, using your calc script verbatim with `coverMap → f` and `picEt → F`, EXIT=0. So the `omit` is right but far too modest: no field, curve, slice, or `Scheme` is needed. And `Equalizer.Presieve.isSheafFor_singleton_iff_of_hasPullback` (`Sites/EqualizerSheafCondition.lean:396`) contains your reduction as an inlined `have h` at lines 388-392 — literally the arbitrary-pairs-to-two-projections step. So "Without this reduction a consumer holding `γ`-invariance would have no target to aim at" is an overclaim: mathlib supplies the target. (I-1410)

**Claim 4 — the retraction is right, the carrier is wrong, and §4 contradicts itself.** The iso is free and axiom-clean, so retracting "the open link" was correct. But the docstring says the RHS is "the base change of the field-extension **self-pullback**". From `#check`, the second leg is `specMapAlgebra k k' : Spec k' ⟶ Spec k`, so the RHS is `T ×_k k' ×_k k'` — **two** `k'`-factors. A base change of the self-pullback would have second leg `pullback.fst sM sM ≫ sM` and **three**. Different object, and the missing factor is the one the Galois indexing lives on. `exact?` fails on the step to the Galois-readable form, and my two `pullbackRightPullbackFstIso`/`pullbackSymmetry` attempts both hit leg-orientation type mismatches — it may still be free, but that is unmeasured. Separately: line 366 says the `T`-relative base change is "**not** the residue either" and line 390 says it is "**open**, and it is now the single link". Those contradict, in one docstring, about one object. (I-1412)

**Claim 7 — the residue *description* is accurate; the two new theorems are not work against it.** §4 names the residue as the coproduct's γ-component inclusion against the two projections. What landed is about `includeLeftRingHom a` and `1 ⊗ₜ a` — the two **ring-level inclusions into the tensor side**. No coproduct, no `sigmaSpec`, no `Spec`, no pullback projection appears in either signature. They are the opposite side of the equivalence, and both close with **one `simp only [galoisSelfTensorEquiv_apply_tmul, ...]`**, EXIT=0 — which contradicts the docstring's own justification that "a residue worth naming is worth checking is not free — these two are". The mathlib-absence claim and the ajc-p1 attribution both survive (`exact?` fails on the `AlgEquiv` form with `[FiniteDimensional] [IsGalois]`). (I-1415)

### The pattern worth acting on

Every refutation above is the same shape: a true, clean statement whose docstring prices generic content as geometric content. The throughput is real — six declarations, zero sorries, one genuine cross-lane join verified — but roughly half of it is a thin instantiation layer over mathlib, and the docstrings are what make it look otherwise. The cheapest fix is to cite `Sieve.overEquiv_ofArrows` and `isSheafFor_singleton_iff_of_hasPullback`, keep only the `picEt`-specific instantiations, and spend the reclaimed room on the scheme-level coherence §4 correctly identifies as still open.

Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentExistence.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/Over.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/EqualizerSheafCondition.lean`.
