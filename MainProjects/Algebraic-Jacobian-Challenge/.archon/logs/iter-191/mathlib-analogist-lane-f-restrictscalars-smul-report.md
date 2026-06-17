# Mathlib Analogist Report

## Mode
api-alignment

## Slug
lane-f-restrictscalars-smul

## Iteration
191

## Question

In `Picard/QuotScheme.lean:650-739`, the `pullback_of_openImmersion_iso_restrict`
helper builds a `Γ(Y, U)`-LinearEquiv between
`Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤)` and `Γ(N, U)`. The
AddEquiv is built (iter-190 SUCCESS); the smul-leg is the residual.

Question: is there a canonical Mathlib lemma at the LinearEquiv level
packaging this (outcome A), is the iter-190 chaining sequence already
the canonical Mathlib idiom (outcome B), or does a project refactor of
the carrier expose a cleaner shape (outcome C)?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. High-level LinearEquiv lemma in Mathlib? | PROCEED (no such lemma) | informational |
| 2. Canonical chaining order | PROCEED (chain identified by iter-190) | informational |
| 3. Step-A elaboration hazard (`restrictScalars.smul_def` doesn't auto-fire because Lean's HSMul resolution doesn't unfold `Scheme.Modules.restrict_obj` even though it's `rfl`) | PROCEED with aliasing-`let` workaround | high |
| 4. Carrier reshape refactor (Γ(Spec _, ⊤)-linear) | DIVERGE_INTENTIONALLY (avoid) | informational |

## Outcome: (B) PROCEED

The iter-190 prover's chaining recipe is the canonical Mathlib idiom.
Mathlib at b80f227 ships all five ingredients but does not bundle them:

- `Scheme.Modules.restrictFunctorIsoPullback` (Sheaf.lean:371) is a
  natural iso of functors with NO `_app_app` / `_top_linearEquiv`
  simp lemma. The Sheaf.lean file ships `_app_app` simps for the OTHER
  restrict-* natural isos (`restrictFunctorId`, `restrictFunctorComp`,
  `restrictFunctorCongr`), but specifically NOT for the
  `restrictFunctorIsoPullback` — that's the Mathlib gap.
- `Scheme.Modules.Hom.app_smul` (Sheaf.lean:110) — already applied by
  iter-190 at L725.
- `Scheme.Modules.map_smul` (Sheaf.lean:95) — migrates Y-side scalar
  through `N.presheaf.map`.
- `Scheme.Hom.appLE_appIso_inv` (OpenImmersion.lean:229) +
  `IsAffineOpen.fromSpec_app_self` (AffineScheme.lean:561,
  `@[elementwise]`) — Stacks 01HH ring identity.
- `ModuleCat.restrictScalars.smul_def` (ChangeOfRings.lean:120, `rfl`,
  `@[simp]`) — definitional smul-unfold for the
  `SheafOfModules.pushforward` action at a section.

## Major

(no ALIGN_WITH_MATHLIB verdicts at proposal stage; the recipe is already
adopted by the project — only the elaboration hazard requires the
aliasing-`let` workaround at the prover side)

## Informational

**Decision 3 critical detail — the elaboration hazard.** Although
`Scheme.Modules.restrict_obj` and `ModuleCat.restrictScalars.smul_def`
are both `rfl` and `@[simp]`, Lean's HSMul instance resolution does NOT
unfold `restrict_obj` during unification. Verified directly via
`lean_multi_attempt` at QuotScheme.lean:739: a `change` to expose the
Y-side smul fails with
`failed to synthesize instance of type class HSMul ↑Γ(Y, hU.fromSpec ''ᵁ ⊤) ↑Γ(N.restrict hU.fromSpec, ⊤) ?m`.

**Workaround** (recommended for the iter-192 prover): introduce an
explicit `let y : ↑Γ(N, hU.fromSpec ''ᵁ ⊤) := (Hom.app isoSheaf.hom ⊤).hom x`
to ALIAS the element under its `restrict_obj`-unfolded type, then the
Y-side smul instance is found because `y`'s declared type has the
natural Y-action registered.

**Concrete iter-192 recipe** (full chain, see analogy file for details):

1. Carry over iter-190 progress (AddEquiv `addEq` built; `Hom.app_smul`
   applied at L725).
2. Aliasing `let` (Decision 3 workaround).
3. `change` to re-express the LHS smul via the Y-side scalar
   `(hU.fromSpec.appIso ⊤).inv.hom ((ΓSpecIso _).inv.hom r)` (rfl by
   `restrictScalars.smul_def`).
4. `rw [Scheme.Modules.map_smul]` to migrate the Y-side scalar through
   `N.presheaf.map (eqToHom hImg.symm).op`.
5. Categorical Stacks 01HH lemma:
   `(ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫ Y.presheaf.map (eqToHom hImg.symm).op = 𝟙`,
   via `appLE_appIso_inv` + `fromSpec_app_self` + `Functor.map_comp` +
   `eqToHom_trans` + poset opens. Apply elementwise to `r`.
6. Final smul-congr closes by `rfl`.

**LOC estimate**: 30-50, with the bulk in Step 5's `eqToHom hImg.symm ≫ homOfLE _ = 𝟙 U` poset bookkeeping.

**Anti-recommendations**:

- Do NOT refactor the carrier to `Γ(Spec _, ⊤)`-linearity. The Stacks
  01HH bridge would just migrate to the consumer
  (`pullback_app_isoTensor_baseMap_sectionLinearEquiv`), not vanish.
- Do NOT chase a high-level Mathlib lemma — `restrictFunctorIsoPullback`
  has no section-level simp lemma; using it doesn't shorten the chain.
- Do NOT attempt `simp [ModuleCat.restrictScalars.smul_def]` blind. The
  instance-resolution failure means simp gets stuck on the smul shape;
  the aliasing-`let` is required.

**Verified via LSP** (b80f227, `lean_multi_attempt`):

- `rfl` and `show _ = _; rfl` fail on the L739 goal — the smul is not
  definitionally equal without the explicit aliasing.
- The categorical `key` statement
  `(ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫ Y.presheaf.map (eqToHom hImg.symm).op = 𝟙 _`
  type-checks cleanly (so the chain target is well-formed; only the
  proof body needs filling).

## Persistent file
- `analogies/lane-f-restrictscalars-smul.md` — full chaining sequence,
  Mathlib citations, and the elaboration-hazard mitigation captured for
  iter-192+ reuse.

Overall verdict: **PROCEED** — chain canonical, iter-192 prover dispatch
licensed, but the directive must include the Decision-3 aliasing-`let`
workaround to avoid a 6th flat iter on the elaboration hazard.
