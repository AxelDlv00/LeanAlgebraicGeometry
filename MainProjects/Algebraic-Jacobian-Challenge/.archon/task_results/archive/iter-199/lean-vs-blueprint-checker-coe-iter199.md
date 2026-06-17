# Lean ↔ Blueprint Check Report

## Slug
coe-iter199

## Iteration
199

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (chapter: `def:indeterminacy_locus`)
- **Lean target exists**: yes — `def indeterminacyLocus` at L146
- **Signature matches**: yes — `Set X` complement of `f.domain`, matches prose "closed complement"
- **Proof follows sketch**: N/A (def body is `(f.domain : Set X)ᶜ`, a one-liner)
- **notes**: Companion `isClosed_indeterminacyLocus` at L151 is present as mentioned in blueprint encoding scope. Blueprint has `\leanok` on statement block; decl is sorry-free. ✓

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (chapter: `def:codim_one_indeterminacy`)
- **Lean target exists**: yes — `def CodimOneFree` at L180
- **Signature matches**: yes — `∀ (x : X), Order.coheight x = 1 → x ∈ f.domain`, matches blueprint's `Order.coheight` encoding
- **Proof follows sketch**: N/A (Prop-valued def)
- **notes**: ✓

### `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` (chapter: `lem:module_free_kaehler_localization`)
- **Lean target exists**: yes — `private theorem module_free_kaehlerDifferential_localization` at L325 (in `AlgebraicGeometry.Scheme` namespace, between the two `namespace RationalMap` blocks)
- **Signature matches**: yes — `Module.Free Sₘ (Ω[Sₘ⁄R])` under `IsLocalization M Sₘ` hypotheses, matches "freeness transports through localisation" prose
- **Proof follows sketch**: yes — applies `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule`, exactly the two-step proof the blueprint names
- **notes**: Blueprint has `\leanok` on statement and proof blocks. Declaration is `private`; this is the project's established pattern for substrate helpers. ✓

### `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` (chapter: `lem:rank_kaehler_localization_eq_relative_dim`)
- **Lean target exists**: yes — `private theorem rank_kaehlerDifferential_localization_eq_relativeDimension` at L351
- **Signature matches**: yes — `Module.rank Sₘ (Ω[Sₘ⁄R]) = n` under `IsStandardSmoothOfRelativeDimension n R S` + localisation
- **Proof follows sketch**: yes — uses `rank_kaehlerDifferential` + `lift_rank_of_isLocalizedModule_of_free` as described
- **notes**: ✓

### `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` (chapter: `lem:smooth_algebra_krull_dim_formula`)
- **Lean target exists**: no — this is an intentionally-future target (Stacks 00OE). The declaration is MISSING from the Lean file and from Mathlib at commit `b80f227`. Blueprint correctly omits `\leanok` and marks it NEEDS-BRIDGE.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Future target pin. The blueprint description is accurate to the Stacks 00OE statement. Not a stale pin — it is the intended declaration name for when the gap closes. ✓ (by convention)

### `\lean{AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue}` (chapter: `lem:cotangent_kahler_over_field`)
- **Lean target exists**: yes — `private noncomputable def cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` at L476
- **Signature matches**: yes — the return type `(RingHom.ker (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ))).Cotangent ≃ₗ[Sₘ] TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) Ω[Sₘ⁄R]` matches the blueprint's iso `m/m² ≅ Ω_{R/k} ⊗_R κ`
- **Proof follows sketch**: yes — the proof follows the 3-step recipe: retraction→injection via `iff_split_injection`, `Ω[κ⁄R] = 0` + exactness → surjection via `exact_kerCotangentToTensor_mapBaseChange`, then `LinearEquiv.ofBijective`. The blueprint names the `kerCotangentToTensor` sequence and the `FormallySmooth` split-injection; both appear in the Lean proof verbatim.
- **notes**: Pin is **correct** — the iso form is the right target for `lem:cotangent_kahler_over_field`. The `finrank_cotangentSpace_of_bijective_algebraMap_residue` alternative would be wrong for this block (it is a downstream finrank application, not the iso itself). Blueprint comment correctly notes the companion siblings. ⚠️ **Missing `\leanok`** on the statement block: the declaration is axiom-clean (no sorry), so `\leanok` should be present. However, the `\lean{...}` pin was added to the blueprint DURING this iter's review phase, AFTER `sync_leanok` ran — so the absence of `\leanok` is an ordering artifact, not a sync error. The next `sync_leanok` will add it.

### `lem:stage6_regular_stalk_assembly` (no `\lean{...}` pin)
- **Lean target exists**: N/A — iter-199 NOTE in blueprint correctly states this lemma has no standalone Lean pin; the 6.C assembly is the in-body closure pattern of `isRegularLocalRing_stalk_of_smooth` rather than a separately-extracted declaration
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The iter-199 NOTE correctly replaces the stale `_aux` pin. No pin needed until the two open sub-gaps close and the proof body is filled. ✓

### `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` (chapter: `lem:smooth_to_regular_local_ring`)
- **Lean target exists**: yes — `private theorem isRegularLocalRing_stalk_of_smooth` at L751
- **Signature matches**: yes — `IsRegularLocalRing (X.left.presheaf.stalk z)` under `[Smooth X.hom] [IsAlgClosed kbar]` plus variety typeclasses; matches the blueprint's "smooth over k̄ ⇒ regular local stalk"
- **Proof follows sketch**: partial — the proof body (L759–L875) faithfully implements Stages 1–6 of the blueprint's six-stage chain up to the sole residual `sorry` on L875. The sorry is exactly the sub-gap (ii.B) = Stacks 00OE Krull-dim formula, documented in the comment block at L836–L874. The closure pattern at L864–L869 is consistent with the blueprint's "Closure pattern (post-(ii.B))" in `lem:stage6_regular_stalk_assembly`.
- **notes**: Blueprint `\leanok` on statement block is correct (declaration exists). Proof block has no `\leanok` (correct — sorry present). This is the new iter-199 pin; the Lean declaration is `private` but this is the project's established pattern. ✓

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (chapter: `lem:smooth_codim_one_dvr`)
- **Lean target exists**: yes — `theorem localRing_dvr_of_codim_one` at L964 (public)
- **Signature matches**: yes — `IsDiscreteValuationRing (X.left.presheaf.stalk z)` under `Order.coheight z = 1`; matches blueprint's "DVR at codim-1 point"
- **Proof follows sketch**: partial — the Lean proof correctly routes through `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (which carries the transitive sorry from `isRegularLocalRing_stalk_of_smooth`) and closes via `IsDiscreteValuationRing.TFAE.out 0 4`. The mathematical steps match the blueprint.
- **notes**: Blueprint `\leanok` on statement block (correct). Proof block has no `\leanok` (correct — transitive sorry). The iter-185 NOTE in the tex correctly documents why `\leanok` is absent. ✓

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (chapter: `thm:codim_one_extension`)
- **Lean target exists**: yes — `theorem extend_of_codimOneFree_of_smooth` at L1033 (public, in `RationalMap` namespace)
- **Signature matches**: yes — `∃! (g : X.left ⟶ Y.left), g.toRationalMap = f` under `[IsProper Y.hom]` + `CodimOneFree f`; matches blueprint's "unique regular extension"
- **Proof follows sketch**: N/A (body is `sorry` at L1072; Steps 1–2 are documented in the comment block)
- **notes**: Blueprint `\leanok` on statement block. Proof block has no `\leanok`. ✓

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (chapter: `lem:milne_codim1_indeterminacy`)
- **Lean target exists**: yes — `theorem indeterminacy_pure_codim_one_into_grpScheme` at L1101 (public)
- **Signature matches**: yes — `indeterminacyLocus f = ∅ ∨ ∀ x ∈ indeterminacyLocus f, ∃ z, Order.coheight z = 1 ∧ x ∈ closure {z}`; matches blueprint's "empty or pure codim-1" disjunction
- **Proof follows sketch**: N/A (body is `sorry` at L1147)
- **notes**: ✓

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (chapter: `lem:mem_domain_partial_map_reshuffle`)
- **Lean target exists**: yes — `theorem mem_domain_iff_exists_partialMap_through_point` at L1213 (public)
- **Signature matches**: yes — the iff between `W.point ∈ f.domain` and `∃ g, g.toRationalMap = f ∧ W.point ∈ (g.domain : Set X.left)`; matches blueprint's reshuffled definitional equivalence
- **Proof follows sketch**: yes — `rw [Scheme.RationalMap.mem_domain]; exact ⟨fun ⟨g, hxg, hg⟩ => ⟨g, hg, hxg⟩, ...⟩`; exactly the "reorder two conjuncts" content the blueprint describes
- **notes**: Blueprint `\leanok` on statement block ✓. **Minor gap**: proof block (`\begin{proof}` at tex L1185) lacks `\leanok` even though the Lean proof is axiom-clean (no sorry). `sync_leanok` should add `\leanok` to this proof block; its absence appears to be a sync oversight from prior iters.

---

## Directive questions — focused answers

### Q1: Correct pin for `lem:cotangent_kahler_over_field`

**Confirmed: the iso form is the correct pin.** The blueprint pin should point to `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` (the `LinearEquiv` at L476), NOT to `finrank_cotangentSpace_of_bijective_algebraMap_residue` (the downstream finrank theorem at L615).

Rationale: `lem:cotangent_kahler_over_field`'s prose describes the iso `m/m² ≅ Ω_{R/k} ⊗_R κ`. The iso-form helper provides exactly this as a `LinearEquiv`. The `finrank` helper is a consequence that computes `Module.finrank κ (CotangentSpace Sₘ) = n`; it belongs in a separate blueprint block (see Q4 below). The blueprint's current pin to the iso form is **correct** and should be kept.

The iter-199 prover task report's recommendation to use the iso form is **confirmed correct**.

### Q2: Stage 6 (ii.A) ↔ (ii.B) split accuracy

The mathematical split is accurately reflected: sub-gap (ii.A) = Stacks 02JK cotangent iso is now RESOLVED (all 4 helpers are axiom-clean), and sub-gap (ii.B) = Stacks 00OE Krull-dim formula is the sole remaining gap.

**Cosmetic inconsistency found**: The Lean docstring uses the label "sub-gap (ii.A)" for the 02JK content (Stacks 02JK = resolved) and "sub-gap (ii.B)" for the 00OE content (remaining), whereas the blueprint labels Stage **6.A** = 00OE and Stage **6.B** = 02JK. The A/B index assignment is inverted between the two sources. This is purely cosmetic (both sides correctly identify which gap is open vs closed) but will confuse anyone cross-referencing the Lean docstring against the blueprint subsection headers.

### Q3: Stale `\lean{...}` pins

No stale pins found. All `\lean{...}` references in the chapter either:
- Point to declarations that exist in the Lean file with matching signatures, OR
- Point to intentional future targets (`lem:smooth_algebra_krull_dim_formula` → Stacks 00OE NEEDS-BRIDGE) with `\leanok` correctly absent, OR
- Are intentionally detached (`thm:weil_divisor_obstruction` — the iter-179 NOTE documents this correctly)

The one missing `\leanok` on `lem:cotangent_kahler_over_field` and the missing `\leanok` on the `lem:mem_domain_partial_map_reshuffle` proof block are timing/sync artifacts, not pin errors.

### Q4: New substrate helpers — should any get standalone blueprint pins?

Of the 4 new iter-199 helpers:

| Helper | Current status | Recommendation |
|--------|---------------|----------------|
| `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` | Pinned at `lem:cotangent_kahler_over_field` | ✓ Correct placement |
| `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue` | Mentioned in comment only | Minor: could get a named remark; not substantive enough for a full `\begin{lemma}` block (it is a 2-line `rw`-transport of the iso above) |
| `finrank_cotangentSpace_of_formallySmooth_residue` | Mentioned in comment only | **Should be promoted**: this is the direct κ-finrank conclusion that `isRegularLocalRing_stalk_of_smooth` will consume via `IsRegularLocalRing.iff_finrank_cotangentSpace` once sub-gap (ii.B) closes. A standalone `\begin{lemma}` block would make the closure pattern explicit. |
| `finrank_cotangentSpace_of_bijective_algebraMap_residue` | Mentioned in comment only | **Should be promoted**: the Lean docstring's "Closure pattern (post-(ii.B))" at L864–L869 explicitly invokes this helper by name. It is the bundled closed-point form that the actual closure step will call. Lack of a blueprint pin leaves the closure path undocumented at the blueprint level. |

The blueprint-writer subagent should add two new `\begin{lemma}` blocks (or a combined block) for `finrank_cotangentSpace_of_formallySmooth_residue` and `finrank_cotangentSpace_of_bijective_algebraMap_residue` in `\subsec:stage6_subgap_decomposition`, positioned after `lem:cotangent_kahler_over_field` and before `lem:stage6_regular_stalk_assembly`.

---

## Red flags

### Placeholder / suspect bodies
None beyond the 3 documented sorries:
- `isRegularLocalRing_stalk_of_smooth` L875: documented sub-gap (ii.B) — Stacks 00OE. Blueprint `lem:smooth_to_regular_local_ring` proof block has no `\leanok`. ✓
- `extend_of_codimOneFree_of_smooth` L1072: documented Stacks 0AVF gap. Blueprint `thm:codim_one_extension` proof block has no `\leanok`. ✓
- `indeterminacy_pure_codim_one_into_grpScheme` L1147: documented function-field-pullback + diagonal intersection gap. Blueprint `lem:milne_codim1_indeterminacy` proof block has no `\leanok`. ✓

Total sorry count: 3 (unchanged from pre-iter-199, consistent with directive).

### Excuse-comments
None. The sorry-body comments in all three above cases are substantive gap-identification notes (naming the Stacks tag, describing what's missing, projecting the closure pattern), not "wrong but works for now" excuses. ✓

### Axioms / Classical.choice on non-trivial claims
None — the 4 new iter-199 helpers are all axiom-clean as documented. The Lean file's existing `private` helpers (Stages 1–5b) were already verified axiom-clean in prior iters.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` blueprint pin but are **helpers** (not substantive standalone results):

- `isClosed_indeterminacyLocus` (L151) — auxiliary closedness witness; blueprint encoding scope at `def:indeterminacy_locus` mentions it but doesn't pin it. Acceptable.
- `stalkMap_flat_of_smooth` (L227) — Stage 1 helper; mentioned in `isRegularLocalRing_stalk_of_smooth` docstring as "axiom-clean (iter-191)" but not separately pinned. Acceptable.
- `exists_isStandardSmooth_at_of_smooth` (L244) — Stage 2 helper. Acceptable.
- `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth` (L273) — Stage 3 helper. Acceptable.
- `module_free_kaehlerDifferential_of_isStandardSmooth` (L304) — Stage 4 helper. Acceptable.
- `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` (L393) — Stage 6.B RHS substrate (iter-198). Mentioned in `isRegularLocalRing_stalk_of_smooth` docstring at L700–L706. No standalone pin. Acceptable given its role as intermediate substrate; could receive a minor pin if the blueprint-writer wants to trace the iter-198 work.
- `finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension` (L423) — Stage 6.B RHS alternate form. Acceptable as helper.
- `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` (L476) — **PINNED** at `lem:cotangent_kahler_over_field`. ✓
- `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue` (L527) — see Q4 above. Minor promotion opportunity.
- `finrank_cotangentSpace_of_formallySmooth_residue` (L563) — see Q4 above. **Should be pinned**.
- `finrank_cotangentSpace_of_bijective_algebraMap_residue` (L615) — see Q4 above. **Should be pinned**.
- `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth` (L648) — Stage 6 sub-gap (i) helper (iter-198). Mentioned in docstring. Acceptable.
- `isRegularLocalRing_stalk_of_smooth` (L751) — **PINNED** at `lem:smooth_to_regular_local_ring`. ✓
- `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (L896) — intermediate private helper; deliberately not pinned (blueprint routes through `lem:smooth_codim_one_dvr` which calls this). Acceptable.

---

## Blueprint adequacy for this file

- **Coverage**: 8 of the 14 substantive declarations (excluding the 7 purely intermediate private Stage 1–5/6.B helpers that are not blueprint-level results) have a corresponding `\lean{...}` block. The 4 iter-199 helpers: 1 pinned, 3 in comments only. Unreferenced declarations are either helpers (acceptable) or the 2 flagged promotion candidates.
- **Proof-sketch depth**: **adequate**. Every `\begin{proof}` block contains enough detail to guide formalization: Steps 1–2 of `thm:codim_one_extension` are described with the correct mathematical content (valuative criterion + local-cohomology vanishing); the 4-substep structure of `lem:milne_codim1_indeterminacy`'s proof matches the Lean comment block; the Stacks 02JK closed-point recipe in `lem:cotangent_kahler_over_field` matches the iter-199 3-step proof. The Stage 6.C assembly proof (in `lem:stage6_regular_stalk_assembly`) accurately describes the closure pattern.
- **Hint precision**: **precise** for existing pins. The one looseness is `lem:cotangent_kahler_over_field`'s note block calling the helpers "private theorem" when two of them are `private noncomputable def` (iso-type results are `def`, not `theorem` in Lean 4). Minor documentation inaccuracy; no mathematical impact.
- **Generality**: **matches need**. No over-narrowing identified.
- **Recommended chapter-side actions**:
  1. (Minor) Add `\leanok` to the `lem:cotangent_kahler_over_field` statement block (will happen automatically on next `sync_leanok` run).
  2. (Minor) Add `\leanok` to the `lem:mem_domain_partial_map_reshuffle` proof block (sorry-free; `sync_leanok` should have added this in a prior iter but apparently didn't).
  3. (Minor) Add two new `\begin{lemma}` blocks for `finrank_cotangentSpace_of_formallySmooth_residue` and `finrank_cotangentSpace_of_bijective_algebraMap_residue` in `\subsec:stage6_subgap_decomposition`, after `lem:cotangent_kahler_over_field`. These are the direct inputs to the `isRegularLocalRing_stalk_of_smooth` closure pattern (per Lean docstring L864–L869) and deserve their own blueprint entries.
  4. (Minor) Align the A/B index labeling: consider renaming "sub-gap (ii.A)" / "sub-gap (ii.B)" in the Lean docstring to "sub-gap (6.B)" / "sub-gap (6.A)" to match the blueprint's `lem:smooth_algebra_krull_dim_formula` (= 6.A) and `lem:cotangent_kahler_over_field` (= 6.B) labels, or vice versa.

---

## Severity summary

- **must-fix-this-iter**: None.
- **major**: None.
- **minor**:
  - Missing `\leanok` on `lem:cotangent_kahler_over_field` statement block (sync ordering artifact; auto-fixed next run)
  - Missing `\leanok` on `lem:mem_domain_partial_map_reshuffle` proof block (sorry-free decl; persistent sync oversight)
  - No standalone blueprint blocks for `finrank_cotangentSpace_of_formallySmooth_residue` and `finrank_cotangentSpace_of_bijective_algebraMap_residue` (both are named in the `isRegularLocalRing_stalk_of_smooth` closure pattern but undocumented at the blueprint level)
  - Cosmetic label inversion: Lean docstring "sub-gap (ii.A)" = 02JK ↔ blueprint "6.B" = 02JK (and "sub-gap (ii.B)" = 00OE ↔ "6.A" = 00OE) — the letters A and B are assigned in opposite order

**Overall verdict**: CodimOneExtension iter-199 is mathematically sound — the 4 new substrate helpers faithfully implement the Stacks 02JK closed-point cotangent iso as documented in the blueprint; the (ii.A)/(ii.B) split is accurately reflected with (ii.A) now axiom-clean and (ii.B) = Stacks 00OE as the sole remaining gap; no placeholder abuse or signature mismatches found; the iso-form pin for `lem:cotangent_kahler_over_field` is the correct choice.
