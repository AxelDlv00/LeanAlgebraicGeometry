# Session 214 — review of iter-214

## Metadata
- **Iter / session**: iter-214 / session_214
- **Lane**: TS (Tensor-Substrate; the sole USER-permitted productive lane)
- **Prover mode**: mathlib-build, route (e) (`Localization.Monoidal` instantiation)
- **Project sorry count**: 81 → **81** (net 0)
- **TensorObjSubstrate.lean code sorries**: 4 → **4** (no new sorries)
- **Build**: GREEN; `lean_verify` axioms `{propext, Classical.choice, Quot.sound}` (axiom-clean; the L937 `opaque` warning is the known comment-scan false positive — the word "opaque" appears in the `tensorObj_restrict_iso` docstring)
- **blueprint-doctor**: clean (no orphan chapters, all `\ref`/`\uses` resolve, no new `axiom`s)
- **sync_leanok**: iter 214, sha `3784dd9e`, **+1 / −0**, chapter `Picard_TensorObjSubstrate.tex` (statement-block `\leanok` on the now-existing target lemma; the proof block correctly carries NO `\leanok` — body is a `sorry`)

## Target attempted

### `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (L443) — PARTIAL (d.1 core landed; target sorry NOT closed)

Route (e)'s sole genuinely-new obligation is `(J.W).IsMonoidal` at the module
level, whose `whiskerLeft` field is `W_whiskerLeft_of_W`, whose residual is this
lemma. So the prover correctly reduced route (e) to the same stalkwise lemma the
prior route (d) was attacking — no divergence from the dispatch.

**Step 0 (make-or-break existence check) — NEGATIVE, must build.** Searched
Mathlib for an off-the-shelf `(J.W).IsMonoidal` / monoidal `SheafOfModules` /
`IsLocalization` glue that would collapse the obligation (the route-(e) win
condition). Found `(J.W (A := A)).IsMonoidal` in `Sites/Monoidal.lean` and
`Sites/Point/IsMonoidalW.lean` — but ONLY for a fixed monoidal-closed `A`
(`Cᵒᵖ ⥤ A`), via internal-hom adjunction. Inapplicable: `PresheafOfModules R`
(varying ring) is not `Cᵒᵖ ⥤ A`, and `MonoidalClosed (PresheafOfModules R)` is
verified-absent. No monoidal `SheafOfModules`. **Verdict: no collapse — must
build `(J.W).IsMonoidal` for the module localizer.** `IsMonoidalW.lean` is the
*template to port*, not a usable instance.

**KEY CORRECTION to PROGRESS.md / `analogies/ts-monoidalloc214.md`.** Both state
"no `PresheafOfModules` stalk/fiber/point infra (only `…/Presheaf/ColimitFunctor.lean`)".
**This is WRONG.** `Mathlib/Algebra/Category/ModuleCat/Stalk.lean` (Andrew Yang,
2026) already supplies, for `X : TopCat`, `R : X.Presheaf CommRingCat`,
`M : PresheafOfModules (R ⋙ forget₂ _ _)`:
- `instance : Module (R.stalk x) ↑(TopCat.Presheaf.stalk M.presheaf x)` (the stalk module);
- `PresheafOfModules.germ_smul` (germ / scalar compatibility).

This substantially de-risks ingredient (d.1): the module stalk does NOT need to
be built. (A pre-existing memory `ts-module-stalk-exists.md` already recorded
this; the prover re-confirmed and the memory was updated.)

**Built this iter (d.1 core, 4 decls, all axiom-clean):**
- `stalkLinearMap` — the `R.stalk x`-linear stalk map of a `PresheafOfModules`
  morphism `g`. `toFun` = the induced Ab-stalk map
  `(stalkFunctor AddCommGrpCat x).map ((toPresheaf _).map g)`; `map_add'` = `map_add`;
  `map_smul'` = a germ chase over the common refinement `W = U ⊓ V` of the germ
  witnesses for the scalar `r` and section `s`
  (`germ_exist` → `germ_res_apply` → `germ_smul` → `stalkFunctor_map_germ_apply`
  → `toPresheaf_map_app_apply`). This is the R_x-linearity Mathlib's `Stalk.lean`
  leaves open.
- `stalkLinearMap_germ` — germ characterisation.
- `stalkLinearMap_bijective_of_isIso` — bijectivity from an Ab-stalk iso
  (`change Function.Bijective ⇑(…)` then `ConcreteCategory.bijective_of_isIso _`).
- `stalkLinearEquivOfIsIso` — the bundled `≃ₗ[R.stalk x]` version (the exact
  object the `id_{F_x} ⊗ g_x` step consumes via `LinearEquiv.lTensor`).

**Why the target sorry did NOT close — two residual gaps (precise):**
1. **(d.1-bridge)** For the topological site, `(Opens.grothendieckTopology X).W
   ((toPresheaf _).map f) ↔ ∀ x, IsIso ((stalkFunctor Ab x).map ((toPresheaf _).map f))`.
   Two routes: (a) `HasEnoughPoints (Opens.grothendieckTopology X)` (EXISTS,
   `Topology/Sheaves/Points.lean:67`) + `ObjectProperty.…W_iff`
   (`Sites/Point/Conservative.lean:109`) — but `presheafFiber ≅ TopCat.Presheaf.stalk`
   is a still-absent Mathlib TODO (Points.lean L18–22); (b) `WEqualsLocallyBijective`
   + `locally_surjective_iff_surjective_on_stalks` (LocallySurjective.lean:80),
   `app_injective_iff_stalkFunctor_map_injective` / `isIso_iff_stalkFunctor_map_iso`
   (Stalks.lean:512/652). Est. **~80–150 LOC**.
2. **(d.2)** Natural iso `(F ⊗ᵖ_R M).presheaf.stalk x ≅ F_x ⊗_{R.stalk x} M_x`
   identifying `(F ◁ g)_x` with `LinearMap.lTensor F_x (stalkLinearMap g x)`.
   "Tensor commutes with the filtered colimit defining the stalk" over the
   **varying** ring — genuinely Mathlib-absent, the **largest piece (~150–250 LOC)**.
   Once it lands: `stalkLinearMap_bijective_of_isIso` + `LinearEquiv.lTensor`
   finish flatness-free.

**Restructure required (flagged by prover, valid):** the lemma is stated over a
GENERAL site `C` where no stalks exist. It must be **specialised to `C = Opens X`**
(or take `[HasEnoughPoints J]` + topological hypotheses). The decl is **UNPROTECTED**
(not in `archon-protected.yaml`) and its only consumer chain
(`W_whiskerLeft/Right_of_W` → `tensorObj_assoc_iso`) already runs over
`Opens.grothendieckTopology X`, so specialising is compatible.

**Dead ends (do NOT retry):** section-level injectivity-alone (needs Tor₁/flatness);
the `MonoidalClosed (PresheafOfModules R)` route (verified-absent); the fixed-base
`Sites/Monoidal.lean` / `IsMonoidalW.lean` instances (varying ring ≠ `Cᵒᵖ ⥤ A`).

**Exploratory `lean_run_code` errors observed (resolved before the edit):**
direct `rw` on `stalkFunctor`-map applications fails (`Did not find an occurrence
of the pattern ?f (?x + ?y)`; `failed to synthesize AddCommMonoid (stalk ?m x)`)
because of concrete-category `hom` wrapping. The working pattern is the explicit
germ chase, not rewriting on the stalk map directly.

## Tooling note
- `archon-informal-agent.py --provider auto` returned **HTTP 401 Invalid
  Authentication** (the `MOONSHOT_API_KEY` in env is invalid). Treated as
  unavailable; the prover proceeded on on-disk Mathlib analysis. Recurs from
  prior iters — see recommendations.

## Key findings / patterns
- **A load-bearing factual error in PROGRESS.md/recipe was corrected**: the
  module stalk IS in Mathlib. This is the genuine state change of the iter (it
  shrinks the d.1 unknown from "build the stalk module" to "prove linearity +
  bridge").
- The **germ-chase pattern** (`germ_exist` → common-refinement `W = U ⊓ V` →
  `germ_res_apply` + `germ_smul`) is the reusable recipe for stalk-level linearity
  on `PresheafOfModules`.
- Route (e)'s `(J.W).IsMonoidal` whiskerLeft field reduces to exactly the same
  stalkwise residual route (d) was building — the pivot did not add new Lean
  work, it reframed the *coherence* (associator/unitors) as free from
  `LocalizedMonoidal` once the whisker field lands.

## Blueprint markers updated (manual)
- None this iter. The four new `stalkLinearMap*` declarations are project-local
  supplements, not Mathlib re-exports, so no `\mathlibok`; they are not
  blueprint-pinned (below-blueprint-altitude d.1 scaffolding — see the
  lean-vs-blueprint-checker note in recommendations). The target lemma was not
  renamed, so no `\lean{...}` correction. No stale `\notready` present. `\leanok`
  is sync_leanok's domain (not touched).

## Recommendations
See `recommendations.md`. Headline: the lane is in the 5th consecutive net-zero
window-iter; the planner must confront whether (d.2) (varying-ring
stalk-⊗-colimit interchange, ~150–250 LOC, genuinely Mathlib-absent) is a
fundable multi-iter mathlib-build or the standing USER-escalation trigger. Do
NOT re-dispatch the target without first specialising it to `Opens X`.
