# Lean ↔ Blueprint Check Report

## Slug
flat-iter052

## Iteration
052

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration (this-iter declarations + open sorry)

### `\lean{AlgebraicGeometry.gf_patch_free_imp_flat}` (lem:gf_patch_free_imp_flat, G3.1)
- **Lean target exists**: yes (line 2719–2721)
- **Signature matches**: yes
  - Blueprint: "In the situation of `gf_flat_locality_assembly`, for every `j` the localized section module `(M_j)_f` is flat over `A_f`."
  - Lean: `[Module.Free R M] : Module.Flat R M` — the underlying algebraic fact (`Module.Flat.of_free`), correctly more general than the blueprint's contextual phrasing.
- **Proof follows sketch**: yes — one-liner `Module.Flat.of_free`, consistent with "free ⟹ flat" (Mathlib anchor `lem:mathlib_flat_of_free`).
- **Axiom check**: clean (`propext`, `Classical.choice`, `Quot.sound` only).
- **Notes**: Blueprint prose frames the result in the specific assembly context; Lean provides the general principle. This is appropriate and the `\lean{...}` pin is correct. Blueprint has `\leanok` on statement. ✓

### `\lean{AlgebraicGeometry.gf_flat_base_local_on_source}` (lem:gf_flat_base_local_on_source, G3.3)
- **Lean target exists**: yes (line 2732–2736)
- **Signature matches**: yes, precisely.
  - Blueprint: "Let `R` be a ring, `B` an `R`-algebra, `N` a `B`-module. If for every maximal `Q ⊂ B` the localization `N_Q` is flat over `R`, then `N` is flat over `R`."
  - Lean: `(h : ∀ (Q : Ideal B) [Q.IsMaximal], Module.Flat R (LocalizedModule Q.primeCompl N)) : Module.Flat R N` via `Module.flat_of_isLocalized_maximal`.
- **Proof follows sketch**: yes — direct wrapper over Mathlib anchor `Module.flat_of_isLocalized_maximal`, consistent with blueprint.
- **Axiom check**: clean.
- **Notes**: Perfect alignment. Blueprint has `\leanok` on statement. ✓

### `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}` (lem:gf_stalk_flat_localBase, G3.4) — **KEY FINDING**
- **Lean target exists**: yes (line 2746–2750)
- **Signature matches**: **partial** — substantial semantic mismatch between blueprint and Lean.
  - **Blueprint prose** (lem:gf_stalk_flat_localBase): _"In the situation of `gf_flat_locality_assembly`, let `x ∈ V = D(f)` and let `y ∈ p^{-1}(V)` be a source point with `p(y)` a generization of `x`. Then the stalk `F_y` is flat over the local ring `O_{S,x}`."_ — a stalk-based geometric statement about sheaves.
  - **Blueprint `\uses`**: `{lem:gf_stalk_flat_over_base, lem:mathlib_localization_flat, lem:mathlib_flat_trans}` — declares dependency on G3.2.
  - **Blueprint proof sketch**: "By `gf_stalk_flat_over_base`, `F_y` is flat over `O_{S,p(y)}`. As `p(y)` is a generization of `x`, the comparison map `O_{S,x} → O_{S,p(y)}` is a localization, hence `O_{S,p(y)}` is flat over `O_{S,x}` (localization flat). Transitivity gives the result."
  - **Lean**: `{R R' N} [CommRing R] [CommRing R'] [Algebra R R'] (S : Submonoid R) [IsLocalization S R'] [AddCommGroup N] [Module R' N] [Module R N] [IsScalarTower R R' N] (h : Module.Flat R' N) : Module.Flat R N`
  - The Lean proves a **pure-algebra localization-transitivity result** (if `R'` is a localization of `R` at `S`, and `N` flat over `R'`, then `N` flat over `R`) via `IsLocalization.flat + Module.Flat.trans`. This involves NO stalks, NO sheaves, NO reference to G3.2.
- **Proof follows sketch**: **no** — the Lean proof does NOT call `gf_stalk_flat_over_base` (G3.2) which doesn't exist in Lean. The Lean short-circuits the entire stalk chain by working purely algebraically.
- **Axiom check**: clean.
- **Notes (must-understand)**: The Lean theorem is the correct *algebraic core* that the stalk result would instantiate at `R = O_{S,x}`, `R' = O_{S,p(y)}`, `N = F_y`. However:
  1. The blueprint's `\uses` says G3.4 depends on G3.2 (`gf_stalk_flat_over_base`), but the Lean G3.4 does not depend on G3.2 at all.
  2. G3.2 (`gf_stalk_flat_over_base`) has **no Lean declaration** (blocked by absent `SheafOfModules.stalk`).
  3. The blueprint's proof sketch for G3.4 is stale — it describes a stalk argument that the Lean doesn't implement.
  - **Recommended action**: Add `% NOTE: The Lean pin proves the algebraic core (localization transitivity of flatness: if R' is a localization of R and N is R'-flat, then N is R-flat), which is the stalk-free generalization of this blueprint statement. The stalk application (R = O_{S,x}, R' = O_{S,p(y)}, N = F_y) is the intended geometric use, but requires SheafOfModules.stalk (absent from Mathlib). Update \uses to remove lem:gf_stalk_flat_over_base.`

### `\lean{AlgebraicGeometry.genericFlatness}` (thm:generic_flatness) — sorry body
- **Lean target exists**: yes (line 2765–2856)
- **Signature matches**: yes, with two differences that are deliberate improvements:
  1. Blueprint says "finite-type morphism" — Lean spells it out as `[LocallyOfFiniteType p] [QuasiCompact p]` (= finite type). The Lean has a long comment (lines 2791–2814) explaining the fix: without `[QuasiCompact p]` the theorem is **false** (counterexample given). The blueprint's "finite-type" is ambiguous without the quasi-compact clause; the Lean correctly pins the hypothesis.
  2. Blueprint says "coherent `O_X`-module" — Lean uses `[F.IsQuasicoherent] [F.IsFiniteType]`. Together these define coherence in the project's conventions. Consistent.
  3. Blueprint conclusion: "restriction to `X_U` is `O_U`-flat" — Lean: affine-patch formulation `∀ affine U ≤ V, affine W ≤ p⁻¹U: Γ(F,W) flat over Γ(S,U)`. This is the correct explicit unfolding of the geometric flatness claim on affine patches; equivalent and more proof-friendly.
- **Proof follows sketch**: **no** (sorry body). Justified: the blueprint proof route goes through `gf_stalk_flat_over_base` (G3.2, absent) and `gf_flat_locality_assembly` (no Lean declaration), both blocked by absent `SheafOfModules.stalk`.
- **Axiom check**: has sorry axiom (single `sorry` at line 2856).
- **Blueprint `\leanok` status**: `\leanok` on statement block — **correct** per project conventions (declaration exists with sorry).
- **Notes**: The Lean file's comment at lines 2706–2712 explicitly acknowledges the sorry is honest and names the blocking ingredient (`SheafOfModules.stalk` absent from Mathlib). Blueprint over-promises that the stalk route (G3.2 + assembly) is formalizable in the near term — see Blueprint Adequacy below.

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (thm:generic_flatness_algebraic)
- **Lean target exists**: yes (line 1982–2144)
- **Signature matches**: yes — matches Nitsure §4 source exactly: `A` noetherian domain, `B` finite-type `A`-algebra, `M` finite `B`-module ⟹ `∃ f ≠ 0, M_f` free over `A_f`.
- **Proof follows sketch**: yes — primary route (module-finite `A` case) + dévissage induction (`IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`) + L4 + L5, all consistent with blueprint.
- **Axiom check**: **clean** (`propext`, `Classical.choice`, `Quot.sound` only; verified via `lean_verify`). No sorry axiom.
- **Blueprint `\leanok` status**: `\leanok` on statement block ✓. **Missing `\leanok` on proof block** (lines 74–106 lack it) — see Red Flags below.

---

## Red flags

### Missing `\leanok` on proof blocks (sync_leanok discrepancy)

`thm:generic_flatness_algebraic` and `lem:gf_polynomial_core` proof blocks lack `\leanok` despite both being axiom-clean (verified via `lean_verify`: axioms = `{propext, Classical.choice, Quot.sound}` only). `sync_leanok` should have added proof-block `\leanok` markers. This is either a `sync_leanok` bookkeeping gap or the markers are being suppressed for a reason not apparent from the source. The review agent should verify that `sync_leanok` ran correctly for iter-052.

### Blueprint proof sketch for G3.4 is stale (stalk route not implemented)

`lem:gf_stalk_flat_localBase`'s `\begin{proof}` in the blueprint describes a stalk-based argument ("By `gf_stalk_flat_over_base`…") that the Lean does NOT follow. The `\uses` dependency on `lem:gf_stalk_flat_over_base` is structurally wrong — the Lean G3.4 proof uses only `IsLocalization.flat + Module.Flat.trans` and has no dependency on G3.2. This is an excuse comment in blueprint form: the proof sketch describes a route that cannot be formalized (absent stalk infra) and does not describe what Lean actually does.

### Blueprint proof of `genericFlatness` relies on absent stalk infra

The blueprint proof for `thm:generic_flatness` (lines 2037–2067) invokes:
- `lem:gf_stalk_flat_over_base` (G3.2) — **no Lean declaration**; blocked by `SheafOfModules.stalk` absent from Mathlib
- `lem:gf_flat_locality_assembly` — **no Lean declaration**; blocked by the same

The Lean file (lines 2706–2712) explicitly says: _"the fourth (G3.2, `lem:gf_stalk_flat_over_base`) and the assembly itself are stated in the blueprint over stalks `F_x` of the sheaf of modules, an abstraction that Mathlib's `SheafOfModules` API does NOT yet provide (there is no `SheafOfModules.stalk` / `Scheme.Modules.stalk`)."_ The blueprint's proof route is therefore not formalizable until Mathlib adds stalk support for `SheafOfModules`. The blueprint should carry a `% NOTE:` to this effect so future provers understand the block.

---

## Unreferenced declarations (informational)

The following substantive project-local declarations exist in the Lean file and are NOT `\lean{...}`-pinned in the blueprint:

- `gf_finite_sections_of_basicOpen_finite_cover` (line 2231) — a finite-section cover assembly lemma used in the G1 route. Blueprint has no lemma block for it; it's referenced indirectly through `lem:gf_qcoh_fintype_finite_sections`.
- `gf_affine_qcoh_Gamma_epi`, `gf_qcoh_finite_sections_globally_generated`, `gf_qcoh_finite_sections_of_free_epi`, `gf_affine_finite_standard_subcover`, `gf_finite_gen_iff_free_epi` (lines 2273–2434) — G1 infrastructure helpers with no direct blueprint pins.
- `SheafOfModules.GeneratingSections.map` (line 2438) and `map_isFiniteType` (line 2462) — GF seam-1 engine helpers.
- `gf_localGenerators_restrict` (line 2489), `gf_finiteType_affine_finite_cover_generated` (line 2525), `module_finite_of_ringEquiv_semilinear` (line 2573), `gf_qcoh_finite_sections_of_genSections` (line 2612), `gf_qcoh_fintype_finite_sections` (line 2674) — G1 base-case chain.
- Several `GenericFreeness` helpers: `isLocalization_lift_injective` (blueprint-pinned at `lem:gf_isLocalization_lift_injective` ✓), `pullbackModuleAddEquiv`, `finite_of_pullbackModuleAddEquiv`, `pullback_isScalarTower`, `finite_of_quotientRingEquiv`, `isLocalizedModule_restrictScalars`, `finite_localizedModule_of_isLocalizedModule`, `free_localizationAway_of_away_tower`, `exists_free_localizationAway_moduleFinite`.

Most of these are project-local helpers supporting the G1/G3 chains. The ones worth promoting to blueprint blocks (because they carry substantial proof content) are the G1 chain items (`gf_qcoh_fintype_finite_sections`, `gf_qcoh_finite_sections_of_genSections`) — but those were likely intended for a future blueprint expansion iteration.

---

## Blueprint adequacy for this file

- **Coverage**: ~35 declarations in Lean; ~20 have direct `\lean{...}` pins. Approximately 15 are infrastructure helpers acceptable without blueprint pins.
- **Proof-sketch depth**: **under-specified** for the G3 sub-chain:
  1. `lem:gf_stalk_flat_localBase` (G3.4): proof sketch incorrectly states the route (stalk + G3.2) vs what Lean implements (pure-algebra transitivity). The prose should be rewritten to describe the algebraic-localization route.
  2. `thm:generic_flatness` proof sketch (via `gf_flat_locality_assembly`): the route through G3.2 (stalks) is blocked indefinitely by absent Mathlib stalk API. Blueprint should carry a `% NOTE:` clarifying that the sorry is honest and the stalk route is not formalizable until `SheafOfModules.stalk` appears in Mathlib.
- **Hint precision**: **loose** for G3.4. The `\uses` list for `lem:gf_stalk_flat_localBase` includes `lem:gf_stalk_flat_over_base` which the Lean proof does NOT use and which has no Lean declaration. This `\uses` entry is dead weight and misleading.
- **Generality**: **matches need** for G3.1 and G3.3 (Lean correctly generalizes the contextual blueprint statements). **Overly narrow framing** for G3.4 (blueprint describes a specific stalk situation; Lean correctly identifies the general algebraic principle).
- **Recommended chapter-side actions**:
  1. **G3.4 (`lem:gf_stalk_flat_localBase`)**: Add `% NOTE:` before the lemma statement: the Lean pin proves the stalk-free algebraic engine (localization transitivity of flatness); the geometric application to stalks requires `SheafOfModules.stalk` (absent from Mathlib). Rewrite the proof sketch to describe the algebraic route (not the stalk route). Remove `lem:gf_stalk_flat_over_base` from `\uses`.
  2. **`thm:generic_flatness`**: Add `% NOTE:` inside the proof block: the sorry is justified — the proof route through `gf_flat_locality_assembly` (and hence `gf_stalk_flat_over_base`) is blocked by `SheafOfModules.stalk` being absent from Mathlib; the sorry will remain until that API is added.
  3. **`thm:generic_flatness_algebraic` proof block**: Investigate `sync_leanok` — the proof block should carry `\leanok` since the declaration is axiom-clean.

---

## Severity summary

| Finding | Severity |
|---|---|
| G3.4 blueprint `\uses` includes non-existent G3.2 dep; proof sketch describes stalk route Lean doesn't take | **major** |
| Blueprint `thm:generic_flatness` proof route (G3.2 + assembly) permanently blocked by absent `SheafOfModules.stalk` in Mathlib; no `% NOTE:` | **major** |
| `thm:generic_flatness_algebraic` and `lem:gf_polynomial_core` proof blocks lack `\leanok` despite both being axiom-clean (sync_leanok gap) | **minor** |
| G3.1 (`gf_patch_free_imp_flat`): signature match ✓, axiom-clean ✓ | — |
| G3.3 (`gf_flat_base_local_on_source`): signature match ✓, axiom-clean ✓ | — |
| G3.4 (`gf_stalk_flat_localBase`): axiom-clean ✓; but see major finding above | — |
| `genericFlatness`: sorry justified and documented in Lean; `\leanok` on statement correct | — |
| `genericFlatnessAlgebraic`: axiom-clean ✓, full dévissage closed | — |

**Overall verdict**: G3.1 and G3.3 are correctly formalised and blueprint-faithful; G3.4's blueprint statement describes the wrong (stalk-based) route — the Lean is the correct algebraic engine but the blueprint prose and `\uses` need updating. The genericFlatness sorry is honest and documented. Two major blueprint-side actions needed (G3.4 `% NOTE:` + `thm:generic_flatness` `% NOTE:`); no must-fix-this-iter blocking on the Lean side.

**Declaration count**: 8 `\lean{...}` blocks checked, 2 major blueprint-side findings.
