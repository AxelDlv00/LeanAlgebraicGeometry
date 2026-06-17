# Blueprint review — iter-048

**Reviewer:** blueprint-reviewer subagent  
**Chapters audited:** 7  
**Findings:** 9 (3 MUST-FIX, 3 SHOULD-FIX, 3 LOW)  
**Unstarted-phase proposals:** 1 (SNAP-S1/S3, BLOCKED on Q1)

---

## Top-level summaries

| Category | Count | Details |
|---|---|---|
| Incomplete blocks (no `\lean{}`) | 3 | QuotScheme.tex: 3 gap nodes in gap1/Hfr area |
| Bad lean targets (`\lean{}` pin mismatch) | 1 | `lem:gf_qcoh_finite_sections_globally_generated` — prose ≠ Lean decl |
| Isolated lean_aux nodes | 11 | 10 SNAP layer-1 helpers + 1 GF free-epi |
| Blueprint gaps (no proof sketch) | 0 | All existing blocks have prose |
| Citation issues | 0 | Cross-references consistent |

---

## Hard-gate verdicts

### `Picard_SectionGradedRing.tex`

| Target | Gate | Verdict | Action |
|---|---|---|---|
| `def:sectionMul` (`sectionsMul`) prover | complete + correct | **PASS** | Dispatch |
| `lem:sheafTensorPow_add` (associativity) prover | complete + correct | **FAIL** | See MUST-FIX §1 |

**`def:sectionMul` — PASS rationale.** The block (SectionGradedRing.tex, §3) states the morphism precisely: given open `U` and sections `σ ∈ Γ(U, L^⊗p)`, `τ ∈ Γ(U, L^⊗q)`, the proof sketch constructs the map via:
1. form the elementary tensor in the presheaf tensor product (objectwise `⊗_R` at `U`);
2. apply the sheafification unit `η_U : 𝒫(L^⊗p ⊗_presh L^⊗q) → Γ(U, L^⊗(p+q))` (which factors through the canonical iso `L^⊗p ⊗_sh L^⊗q ≅ L^⊗(p+q)` supplied by `lem:sheafTensorPow_add`);
3. bilinearity from bilinearity of `⊗` and `Γ(η)`-linearity.

All three steps have available Lean infrastructure (presheaf TP bilinearity, `sheafificationUnit`, and `lem:sheafTensorPow_add` as a `\uses` dep). The `sectionsMul` object in Lean is a section-level multiplication map `Γ(U, L^⊗p) →+ Γ(U, L^⊗(p+q))` parametric in sections; this maps directly to the proof sketch. **Dispatch the `sectionsMul` prover.**

**`lem:sheafTensorPow_add` — FAIL rationale.** The proof sketch (SectionGradedRing.tex, §1) says:

> "The canonical coherence isomorphisms $L^{\otimes p} \otimes L^{\otimes q} \cong L^{\otimes(p+q)}$ are preserved by the sheafification functor."

This is the precise step the iter-047 prover could not close: `SheafOfModules` has no `MonoidalCategory` instance in Mathlib — sheafification is a left adjoint but is NOT known to be strong monoidal. The current sketch glosses the core difficulty. Before dispatching the associativity prover, the block needs:
- explicit acknowledgment that `SheafOfModules.sheafification` is used as a functor, not as a strong monoidal functor;
- a decomposition route: either (a) lift the presheaf-level associator (from `PresheafOfModules.monoidalCategory`) through the sheafification adjunction, proving naturality of the adjunction unit makes the triangle commute; or (b) establish associativity directly on sections via a sections-level calculation.

**Do not dispatch the associativity prover until route (a) or (b) is spelled out in the sketch.**

---

### `Picard_FlatteningStratification.tex`

| Target | Gate | Verdict | Action |
|---|---|---|---|
| Seam-1 `lem:gf_finiteType_affine_finite_cover_generated` prover | complete + correct | **PASS** | Dispatch |
| G3 `lem:gf_flat_locality_assembly` prover | complete + correct | **FAIL** | See MUST-FIX §2 |
| `\lean{}` pin on `lem:gf_qcoh_finite_sections_globally_generated` | correct | **FAIL** | See MUST-FIX §3 |

**Seam-1 — PASS rationale.** `lem:gf_finiteType_affine_finite_cover_generated` (FlatteningStratification.tex, line ~1613) has a complete proof sketch with three primitives: (1) scheme-finite-type → affine finite cover; (2) each patch affine globally generated; (3) restrict to this cover. No `\leanok` yet (unproved), but the sketch is formalizable. The three primitives have Lean/Mathlib analogues. **Dispatch the seam-1 prover.**

**G3 — FAIL rationale.** `lem:gf_flat_locality_assembly` (FlatteningStratification.tex, line ~1822) remains thin. The proof sketch says: "On each patch `Spec A_f`, the sheaf restricts to a free module; flat modules are defined by extension of scalars + faithfully-flat descent; conclude globally flat." This glosses:
- the concrete Lean API for `Module.Flat` locality (the `Module.Flat.iff_exists_free_of_*` family or `RingHom.Flat.of_localization_span`);
- the transition from sheaf-local freeness to stalk-local flatness to global flatness;
- which localization-cover lemma bridges `AlgHom.IsLocalization` to `Module.Flat`.

The iter-047 flagging stands: the proof is not formalizable from the current sketch. Must expand with concrete Mathlib lemma names before dispatching.

---

## Per-chapter checklist

| Chapter | Complete | Correct | Notes |
|---|---|---|---|
| `Cohomology_FlatBaseChange.tex` | ✓ | ✓ | `_legs_conj` keystone PARKED (off-critical-path); FBC-A2 `base_change_map_affine_local` `\leanok`; FBC-B `gammaTopEquivEqLocus`/`baseChangeGammaEquiv` `\leanok` |
| `Cohomology_RegroupHelper.tex` | ✓ | ✓ | Single-lemma chapter; `\leanok` |
| `Picard_GrassmannianCells.tex` | ✓ | ✓ | All phases (cells/cocycle/glue/sep/proper) `\leanok` per STRATEGY |
| `Picard_RelativeSpec.tex` | ✓ | ✓ | `thm:relative_spec_exists`, `thm:relative_spec_univ` `\leanok`; proof sketches cite Stacks |
| `Picard_QuotScheme.tex` | **partial** | ✓ | 3 blocks missing `\lean{}` pins (see SHOULD-FIX §1); rest of chapter correct |
| `Picard_SectionGradedRing.tex` | **partial** | **partial** | `def:sectionMul` PASS; `lem:sheafTensorPow_add` sketch inadequate (MUST-FIX §1); 10 SNAP aux nodes need `private` (LOW §1) |
| `Picard_FlatteningStratification.tex` | **partial** | **partial** | Seam-1 PASS; G3 thin (MUST-FIX §2); `\lean{}` pin mismatch (MUST-FIX §3); `gf_qcoh_finite_sections_of_free_epi` unpinned (SHOULD-FIX §2) |

---

## Findings

### MUST-FIX

**§1. `Picard_SectionGradedRing.tex` — `lem:sheafTensorPow_add` proof sketch glosses Mathlib-absent strong-monoidality**

The sketch says "coherence isomorphisms preserved by sheafification". This is not established in Mathlib and was the iter-047 blocker. The block must:
- Remove the gloss and replace it with an explicit route. Recommended route A: "In `PresheafOfModules`, the associativity natural isomorphism `(F ⊗_presh G) ⊗_presh H ≅ F ⊗_presh (G ⊗_presh H)` exists (from `PresheafOfModules.monoidalCategory`); applying the sheafification left adjoint and the uniqueness of the unit-nat-iso, this descends to `SheafOfModules` by the naturality square `η ∘ α_presh = α_sh ∘ (η ⊗ η)` where `η` is the sheafification unit."
- OR route B: "By induction on `p`: for `p = 0` trivial; for `p+1`, `L^⊗(p+1+q) = L^⊗(p+q) ⊗_sh L` and `(L^⊗(p+1)) ⊗_sh L^⊗q = (L^⊗p ⊗_sh L) ⊗_sh L^⊗q`, use `SheafOfModules.tensorAssoc` (if available) or carry the induction through `Γ(U,-)` and use global sections bijectivity."

Route A requires checking whether `η ∘ α_presh = α_sh ∘ (η ⊗ η)` naturality holds for the sheafification adjunction unit — this must be verified in Lean before the sketch can say it's available. **Writer-pass required before prover dispatch.**

**§2. `Picard_FlatteningStratification.tex` — `lem:gf_flat_locality_assembly` (G3) too thin**

The proof sketch must be expanded with:
1. Concrete Mathlib locality-of-flatness lemma name (e.g., `Module.Flat.of_isLocalization_span` or equivalent).
2. The bridge from sheaf-local freeness on a basic-open cover to `Module.Flat` on each stalk localization.
3. The assembly step: once all stalk localizations are flat, conclude global flatness via the appropriate `Module.Flat.iff_*_localization` criterion.

**Writer-pass required before G3 prover dispatch.**

**§3. `Picard_FlatteningStratification.tex` — `\lean{}` pin mismatch on `lem:gf_qcoh_finite_sections_globally_generated`**

The block's prose states: "free epi → finite sections" (sheaf epi where source is a free module sheaf → target has finite sections). The existing `\lean{}` pin is `gf_finite_sections_of_basicOpen_finite_cover` (the locality assembly), not the free-epi lemma. The actual free-epi Lean decl is `gf_qcoh_finite_sections_of_free_epi` (isolated lean_aux node, unpinned).

Fix required: either (a) create a new blueprint block `lem:gf_qcoh_sections_free_epi` with `\lean{gf_qcoh_finite_sections_of_free_epi}`, keeping the existing block for the locality assembly with its current pin; or (b) adjust the prose of the existing block to match the more general Lean statement and re-pin accordingly.

**Must be resolved before any GF-free-epi prover dispatch.**

---

### SHOULD-FIX

**§1. `Picard_QuotScheme.tex` — 3 blocks in gap1/Hfr section have no `\lean{}` pins**

The following blocks have `\leanok`-bearing Lean decls that are unconnected to the blueprint:
- `lem:composite_immersion_flocus_basicOpen` — composite of open immersions into flocus; Lean decl exists in `QuotScheme.lean` (gap1 area, proved in iter-041)
- `lem:gamma_image_iso_semilinear_top` — Γ image ISO for semilinear top; Lean decl proved in iter-041
- `lem:flocus_section_scalar_tower` — scalar tower for flocus sections; Lean decl proved in iter-041

Since gap1 is DONE per STRATEGY, these blocks just need `\lean{<decl-name>}` pins. Writer-pass: locate the three Lean declaration names (likely in `AlgebraicJacobian/Picard/QuotScheme.lean`, iter-041 pass) and add the pins.

**§2. `Picard_FlatteningStratification.tex` — `gf_qcoh_finite_sections_of_free_epi` is an isolated lean_aux node**

This is the free-epi helper referenced in the NOTE at line ~1740. It is the genuine content of the `lem:gf_qcoh_finite_sections_globally_generated` block (once the prose/Lean mismatch is fixed per MUST-FIX §3). Until §3 is resolved, this node will remain isolated. After §3, the node will be wired up via the new `\lean{}` pin.

---

### LOW

**§1. 10 SNAP layer-1 `lean_aux` helpers should be `private`**

The 10 isolated nodes with prefix `AlgebraicGeometry.Scheme.Modules.*` are internal implementation helpers for `def:sheafTensorObj` / `def:sheafTensorPow` / `def:sectionMul` in `SectionGradedRing.lean`. They implement the public API that IS connected to the DAG. They do not need separate blueprint blocks. Mark them `private` in Lean (or `attribute [local private]`) to remove them from the blueprint node set.

---

## Unstarted-phase proposals

### SNAP-S1/S3 — section-module input + Φ_s extraction
**Status:** BLOCKED on Q1 (canonicity of Φ_s; see STRATEGY Q1).  
**Blueprint coverage:** zero (no chapter exists).  
**Proposed outline** (do NOT act until Q1 is resolved):

```
## Chapter: Picard_SectionGradedModule.tex

§1. Section-module input
  def:sectionGradedModule_input
    \uses{def:sectionGradedRing, def:sheafTensorPow, def:sheafModuleTwist}
    Statement: L^⊗n ⊗_sh M carries a graded S(L)-module structure

§2. Hilbert regularity cutoff
  lem:regularity_twist_acyclic
    \uses{def:sectionGradedRing, thm:serre_finiteness}
    Statement: ∃ m₀ ∀ n ≥ m₀, H¹(X, L^⊗n ⊗_sh M) = 0

§3. Φ_s map
  def:phi_s
    \uses{lem:regularity_twist_acyclic, def:sectionGradedModule_input}
    Statement: presentation map Φ_s : (chosen free graded module) → Γ_*(L,M)

  lem:phi_s_surjective
    \uses{def:phi_s}
    Statement: Φ_s is surjective (for n ≥ m₀)

  lem:phi_s_canonical_above_m0
    \uses{def:phi_s, lem:phi_s_surjective}
    Statement: two choices of m₀ yield the same Φ_s in degrees ≥ max(m₀, m₀')
    [Route (a): cited Serre-agreement; Route (b): H¹-free finiteness argument]
```

Trigger: dispatch reference-retriever for Q1 route (b) (H¹-free finiteness with Stacks citation) FIRST; only write this chapter after Q1 is resolved.

---

## Severity summary

| Severity | Count | Items |
|---|---|---|
| MUST-FIX | 3 | SectionGradedRing `sheafTensorPow_add` sketch; FlatteningStratification G3 sketch; `\lean{}` pin mismatch `gf_qcoh_finite_sections_globally_generated` |
| SHOULD-FIX | 2 | QuotScheme 3 gap-node pins; `gf_qcoh_finite_sections_of_free_epi` isolation |
| LOW | 1 | 10 SNAP layer-1 aux nodes → `private` |
| Unstarted-phase proposals | 1 | SNAP-S1/S3 (BLOCKED) |
