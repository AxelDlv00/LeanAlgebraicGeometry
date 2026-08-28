All measurements done. Report below.

## A. The three binders at the best concrete candidate — ALL THREE SYNTHESIZE

Probe file `/tmp/AJCProbeFinal.lean`, run as `cd /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge && lake env lean /tmp/AJCProbeFinal.lean`, **EXIT=0**, zero errors, zero warnings. Imports verified current (`lake build AlgebraicJacobian.Picard.FGAPicRepresentability AlgebraicJacobian.Picard.RigidPushforwardP1Witness` → EXIT=0, 8710 jobs, sole warning the line-481 sorry — so this is not the stale-import failure mode).

| binder | verdict | producer |
|---|---|---|
| `SmoothOfRelativeDimension 1 (p1Over k).hom` | SYNTHESIZES | `AlgebraicGeometry.Adelic.instSmoothOfRelativeDimensionOneP1Over`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1Witness.lean:232` (the `p1Over`-spelling restatement of `instSmoothOfRelativeDimensionOneP1OverHom`:199) |
| `IsProper (p1Over k).hom` | SYNTHESIZES | `AlgebraicGeometry.Adelic.isProper_p1Over_hom`, `/home/axel/.../AlgebraicJacobian/Picard/RigidPushforwardP1Constants.lean:176` — `inferInstanceAs (IsProper (ℙ(ULift (Fin 2); Spec (CommRingCat.of k)) ↘ Spec (CommRingCat.of k)))`, i.e. it comes straight from the project's own `ProjectiveSpace.isProper_over`. **`IsProper` was the cheapest of the three, not the hardest.** |
| `GeometricallyIntegral (p1Over k).hom` | SYNTHESIZES | `AlgebraicGeometry.Adelic.instGeometricallyIntegralP1Over`, `RigidPushforwardP1Witness.lean:126`, fed by `instGeometricallyIntegralProjIntegralModel` (:101) over the terminal-based integral model |

All three `#print axioms` clean: `[propext, Classical.choice, Quot.sound]`. No `sorryAx`.

The seam itself elaborates at `p1Over` with all three binders found by synthesis — `Scheme.fgaPicardRepresentability (Adelic.p1Over k)` typechecks, `#print axioms seam_at_p1Over` = `[propext, sorryAx, Classical.choice, Quot.sound]` (the `sorryAx` is the seam's own :489 `sorry`, i.e. exactly the obligation, nothing extra). `Scheme.HasPicSchemeEt (Adelic.p1Over k)` also fires by `infer_instance`.

Two notes on things that do NOT synthesize, neither of which is a binder of the seam:
- `Scheme.HasRationalPoint (Adelic.p1Over k)`: `failed to synthesize instance of type class HasRationalPoint (Adelic.p1Over k)`. Not required by the binders; it only gates clause (2). No producer exists for `p1Over` in AJC (the two producers are `hasRationalPoint_of_isAlgClosed`, `Albanese/AlbaneseUP.lean:289`, and `hasRationalPoint_baseChangeField`, `RiemannRoch/CurveBaseChange.lean:285`). The sibling `Albanese` has explicit points (`ProjectiveLineBar.zeroPt/onePt/inftyPt`) on a *different* object.
- The correct namespace is `AlgebraicGeometry.Scheme.PicScheme.picEt` / `Scheme.fgaPicardRepresentability`, not the unqualified names in the task text.

## B. The concrete curve object

`AlgebraicGeometry.Adelic.p1Over`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforward.lean:552`:

```lean
noncomputable abbrev p1Over (k : Type u) [Field k] : Over (Spec (CommRingCat.of k)) :=
  Over.mk (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)) ↘ Spec (CommRingCat.of k))
```

**Over an arbitrary field in an arbitrary universe `u`** — universe-polymorphic, not stuck at `Scheme.{0}`. Verified at both `k : Type u` general and the fixed `k = ℚ`. This is exactly the `{k : Type u} [Field k]` shape the seam binds, so no `ULift` gymnastics is needed at the seam.

A second, weaker candidate exists: `AlgebraicGeometry.P1.asOver`, `AlgebraicJacobian/RiemannRoch/Ledger/P1.lean:190` (a `Proj (homogeneousSubmodule (Fin 2) k)` model, also universe-`u`). Its `IsProper` synthesizes; I did not find smoothness/geometric-integrality instances for it, so `p1Over` is the witness to use.

## C. Pic of P^1 — nothing, in project or mathlib

Searched with `horizon search` (both projects + mathlib), leansearch, loogle, and grep.

**mathlib v4.31 has no Picard group of a scheme at all.** `grep -rin "picard" Mathlib/AlgebraicGeometry/` returns only three prose lines in `EllipticCurve/Weierstrass.lean`. The only Picard group in mathlib is the *ring-theoretic* `CommRing.Pic R` (`Mathlib/RingTheory/PicardGroup.lean:400`), with `CommRing.Pic.subsingleton_iff` (:497), triviality for local rings (:509) and semilocal rings (:513). Nothing about projective space, nothing about `Proj`, no `Scheme.Pic`.

**The project has a Picard group but no computation of it anywhere.** `AlgebraicGeometry.Scheme.Modules.PicGroup X` = `Quotient (picSetoid X)` at `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:620`, with `picCommGroup` at :654. Grep for `PicGroup` outside that one file returns **zero hits** — it is defined and given a group structure, and never computed, compared, or instantiated at any scheme. No `Subsingleton (PicGroup _)`, no `PicGroup _ ≃ ℤ`, no degree homomorphism out of it.

What does exist near the question, all in `AlgebraicJacobian/Picard/`:
- `ProjectiveSpace.twistingSheaf n₀ S m` (`ProjectiveMorphism.lean:56`) — `O(m)` on `ℙ(n₀; S)`, **restricted to `S : Scheme.{0}`** (a `Type 0` index and a `Scheme.{0}` base; the universe-`u` version does not typecheck: "argument `ULift.{u,0} (Fin 2)` has type `Type u` … but is expected to have type `Type`"). So at `k : Type` it lands on the same scheme as `(p1Over k).left` (measured: typechecks), but at universe `u` it does not exist.
- `ProjTwist.twistingSheaf_isLocallyTrivial` (`SerreTwistSections.lean:1654`), `_isInvertibleGr` (:1710), `_isFinitePresentation` (:1675). `IsInvertible` of `O(m)` is **not** an instance — `infer_instance` gives `type class instance expected (ProjectiveSpace.twistingSheaf … m).IsInvertible` — but it is derivable in three lines from `Scheme.Modules.exists_tensorObj_inverse` applied to `twistingSheaf_isLocallyTrivial` (measured, `/tmp/AJCProbeC.lean`, EXIT=0).
- `ProjTwist.serreTwistZeroEquivInt` (`SerreTwistSections.lean:1574`): `Γ(serreTwist n₀ 0, ⊤) ≃+ ℤ`. This is *global sections of `O(0)`*, not `Pic`.
- Genus-side, not Pic: `subsingleton_hModule_one_p1Over` and `genus_p1Over_eq_zero` (`RiemannRoch/Ledger/P1Vanishing.lean:312`, :323) — `H¹(ℙ¹_k, 𝒪) = 0` and `genus ℙ¹ = 0`, for every field.
- `PicScheme.degree` (referenced `Picard/IdentityComponent.lean:44`, §3 at :1394) is a degree map on `Pic_{C/k}(k)`, and its own file records at :1451 that a previous claim about it was FALSE and it must not be cited as a constructed degree map.

So: **no statement that `Pic(ℙ¹_T) = ℤ`, no `Pic` computation at any scheme, in either the project or mathlib.** The distance from `picEt (p1Over k)` to anything computable is the full gap: there is no lemma that any `X.Modules` line bundle on `ℙ¹` is a twist, and `picEt` is additionally a `presheafToSheaf`-sheafification (`PicEtSheaf.lean:163-166`) of the coset functor, with no descent-to-generators result about it.

## D. Non-vacuity

**YES.** `AlgebraicGeometry.Adelic.p1Over k`, for an arbitrary field `k : Type u`, synthesizes all three instance binders axiom-cleanly, and `Scheme.fgaPicardRepresentability (Adelic.p1Over k)` elaborates with `sorryAx` as its only impurity — so the seam's statement has content over every field, not merely over an empty class of objects.
