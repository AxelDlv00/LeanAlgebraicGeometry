# DualInverse.lean — fine-grained pass (iter-271)

Objective 1: extract `sliceDualTransportInv` as a top-level def FIRST, then close `invFun` +
round-trips of `sliceDualTransport`. Blueprint `lem:slice_dual_transport` (invFun ε-direction
prose corrected this phase).

## Sentence 1: "Extract `sliceDualTransportInv` as a standalone top-level `noncomputable def`" → `sliceDualTransportInv`
- **Result:** RESOLVED (the unstick lever) — the top-level def **TYPECHECKS** (signature accepted,
  no instance-synthesis failure). Inserted at L259, before `sliceDualTransport`, so all leg-B
  helpers (`dualUnitRingSwapHom`, `isIso_ε_restrictScalars_appIso_hom`, …) precede it.
  - Signature: `(f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) (V : (Opens Y)ᵒᵖ)`
    `(β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj)`
    `(ψ : ↑(((pushforward β).obj M.val).dual.obj V)) : ↑(((pushforward β).obj M.val.dual).obj V)`.
  - Body is `refine { app := fun W'' => ?_, naturality := ?_ }`; the per-`W''` goal **surfaces
    cleanly** now (the iter-265 binder-metavar blocker is gone): goal type is
    `(restr fV M.val).obj W'' ⟶ (restr fV 𝟙_X).obj W''` (only depends on `(unop W'').left`).
- **The armed reversing signal is NOT triggered:** the extraction typechecks; the blocker is the
  `app` *morphism*, not the def packaging or `≃ₗ`-by-hand instances.

## Sentence 2: "`invFun` is the reverse `PresheafOfModules.Hom` over `Over fV`" → `sliceDualTransport.invFun`
- **Result:** RESOLVED (wired) — `invFun := fun ψ => sliceDualTransportInv f M V β ψ`
  (`sliceDualTransport` internal holes **4 → 3**: invFun closed). `β` is in scope from `set β`.

## Sentence 3: "down-set facts `P := f⁻¹ᵁ W'`, `f.opensFunctor.obj P = W'`" → app helper `have`s
- **Result:** RESOLVED (axiom-clean) — inside `sliceDualTransportInv.app`:
  - `hW'fV : W' ≤ f ''ᵁ (unop V)` := `(unop W'').hom.le`
  - `hPV : f ⁻¹ᵁ W' ≤ unop V` := `((Opens.map f.base).monotone hW'fV).trans (le_of_eq (f.preimage_image_eq _))`
  - `he : f ''ᵁ (f ⁻¹ᵁ W') = W'` := `image_preimage_eq_opensRange_inf` + `inf_eq_right.mpr (… f.image_le_opensRange …)`.
  - Mathlib names located: `Scheme.Hom.preimage_image_eq`, `Scheme.Hom.image_preimage_eq_opensRange_inf`,
    `Scheme.Hom.image_le_opensRange`, `Scheme.Hom.appIso` (`Γ(X, f''ᵁU) ≅ Γ(Y,U)` for `f : Y ⟶ X`).

## Sentence 4: "the app component morphism (X-slice mirror of `toFun`)" → `sliceDualTransportInv.app` body
- **Result:** PARTIAL (documented `sorry` with full recipe + the down-set facts in place).
- **Recipe verified this iter (the middle is type-correct):** the ψ-reindex
  `(restrictScalars (f.appIso P).hom.hom).map (ψ.app (op (Over.mk (homOfLE hPV))))`
  composed with `dualUnitRingSwapHom f (f⁻¹ᵁ W')` is exactly the forward `toFun`'s mirror and
  type-checks **up to the open `he`**. The source-side change-of-rings collapses because the two
  `restrictScalars` are along inverse ring maps: `(β.app (op P)) = (f.appIso P).inv` and
  `g = (f.appIso P).hom`, so `restrictScalars g ∘ restrictScalars (β.app P) = restrictScalars 𝟙`
  (tools located: `ModuleCat.restrictScalarsComp'App`, `ModuleCat.restrictScalarsId'App`).
- **EXACT BLOCKER (probed via `lean_multi_attempt`):** `dualUnitRingSwapHom f (f⁻¹ᵁ W')` lands in
  `𝟙_ (ModuleCat ↑(X.presheaf.obj (op (f ''ᵁ f ⁻¹ᵁ W'))))`, but the goal target is
  `(restr fV 𝟙_X).obj W'' = 𝟙_ (ModuleCat ↑(X.presheaf.obj (op W')))`. These differ ONLY by the
  open `he : f ''ᵁ f ⁻¹ᵁ W' = W'`, but they are objects of **distinct ModuleCat fibers**
  (`ModuleCat A` vs `ModuleCat B`, `A = X.presheaf(op (f''ᵁf⁻¹ᵁW'))`, `B = X.presheaf(op W')`,
  propositionally-but-not-syntactically-equal rings). A plain `eqToHom ?_` at the ModuleCat level
  **cannot** bridge across fibers (tested: `refine eqToHom ?_ ≫ … ≫ eqToHom ?_` still errors on the
  `dualUnitRingSwapHom` composition; `subst hW'` fails — `W'` is a `set`-local).
- **Genuine close (next pass, ~20–40 LOC):** conjugate the codomain by a `dualUnitRingSwap`-style
  ε-iso along the ring iso `X.presheaf.map (eqToHom (op he))` (i.e. a `restrictScalars`-ε swap for
  the *eqToHom* ring map), the same machinery `dualUnitRingSwapHom` uses for `f.appIso`, applied to
  the open-equality `he`. Mirror on the M-source leg.

## Sentence 5/6: "naturality of the reverse family", "left_inv/right_inv round-trips" → blocked on app
- **Result:** `sorry` (cannot close while `app` is `sorry`). `naturality` = thin-poset
  `Subsingleton.elim` + ε-naturality square; `left_inv`/`right_inv` = `Iso.inv_hom_id`/`hom_inv_id`
  of `f.appIso` + down-set bijection `he`. All consume the `app` morphism.

## Assembly (`sliceDualTransport`)
- invFun wired to `sliceDualTransportInv`; naturality/left_inv/right_inv retain `sorry` (3 holes).
- `dual_restrict_iso` (L642) assembly `isoMk`-naturality `sorry` UNTOUCHED (out of this objective's
  scope; blocked on `sliceDualTransport` being concrete).

## Summary
- **3/6 sentences closed** (extraction typechecks; invFun wired; down-set facts axiom-clean),
  **1 PARTIAL** (app: middle type-correct, blocker pinpointed), **2 blocked-on-app** (naturality,
  round-trips).
- File-level `sorry` declarations: **2 → 3** (added `sliceDualTransportInv`), but
  `sliceDualTransport`'s **internal holes 4 → 3** (invFun closed). Net: the reverse-map work is now
  structured into a named, typechecking top-level def with the precise residual isolated.
- File **compiles, 0 errors**.

## Why I stopped
- **Real progress:** the requested `sliceDualTransportInv` extraction LANDED (typechecks — the
  iter-265 binder-metavar blocker is resolved); `invFun` of `sliceDualTransport` CLOSED (wired);
  the app down-set facts (`hW'fV`, `hPV`, `he`) are axiom-clean and in place.
- **Partial progress:** `sliceDualTransportInv.app` — the ψ-reindex + `dualUnitRingSwapHom` middle
  is type-correct; the SOLE residual is the codomain transport across the `he` open-equality, which
  lives in distinct ModuleCat fibers and needs a `restrictScalars`-ε conjugation along
  `X.presheaf.map (eqToHom (op he))` (NOT a plain `eqToHom`). This is a fresh ~20–40 LOC sub-build,
  not the previously-suspected `≃ₗ`-packaging difficulty.
- **Did NOT achieve** the bar's "axiom-clean `sliceDualTransportInv`": the `app`/`naturality` holes
  remain. **Recommended next:** a `prove` pass on `sliceDualTransportInv.app` with the directive to
  build the `eqToHom`-ring-iso ε-conjugation for the codomain (and source M-leg), then `naturality`
  (Subsingleton.elim + ε-naturality), then `left_inv`/`right_inv` (`f.appIso` cancellation + `he`).

## Blueprint markers
- `lem:slice_dual_transport` statement: already `\leanok`-eligible (decls present). The new
  `sliceDualTransportInv` has no own blueprint env; it realizes the lemma's "Inverse." paragraph
  (`\lean{…dualUnitRingSwapHom}` already present). No marker action needed from prover (sync owns
  `\leanok`).
