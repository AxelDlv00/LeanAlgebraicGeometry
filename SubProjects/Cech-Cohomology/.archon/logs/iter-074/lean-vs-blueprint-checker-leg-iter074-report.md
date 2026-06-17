# Lean ↔ Blueprint Check Report

## Slug
leg-iter074

## Iteration
074

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean` (1306 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated chapter, relevant labels: `lem:coreIso_comm_leg`, `lem:coreIso_comm_coface`, `lem:coreIso_comm_sum`, `lem:coreIso_comm`, `lem:coreIso_obj_iso`, `lem:pushPull_leg_sections`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.coreIso_comm_leg}` (chapter: `lem:coreIso_comm_leg`)
- **Lean target exists**: yes — `lemma coreIso_comm_leg` at line 1035
- **Signature matches**: yes — the Lean statement matches blueprint's prose exactly: the σ'-projection of (G_V∘Ψ(δ^nerve_k)) ≫ objIso(p+1) equals sectionCechFaceRestr(σ',k) applied to the (σ'∘d_k)-component of objIso(p)
- **Proof follows sketch**: partial — the proof structure follows the blueprint's described chain (unwinding `coreIso_objIso_π` on both sides, then invoking the backbone seams), BUT it depends on `pushPull_interLegHom_sections := sorry` (called at line 1074). The step "the coface acts as the F-restriction" is the sorry point, and the blueprint offers no proof sketch for it.
- **notes**: No `\leanok` on blueprint block — correctly absent given the transitive sorry.

### `\lean{AlgebraicGeometry.coreIso_comm_coface}` (chapter: `lem:coreIso_comm_coface`)
- **Lean target exists**: yes — `lemma coreIso_comm_coface` at line 1108
- **Signature matches**: yes — coordinatewise extensionality; the object isos intertwine the individual cofaces, matching blueprint lines 8858–8867
- **Proof follows sketch**: yes — Pi.hom_ext + per-coordinate appeal to `coreIso_comm_leg`, exactly as described in blueprint lines 8870–8880
- **notes**: No `\leanok` on blueprint block — correctly absent (transitive sorry via `coreIso_comm_leg`).

### `\lean{AlgebraicGeometry.coreIso_comm_sum}` (chapter: `lem:coreIso_comm_sum`)
- **Lean target exists**: yes — `lemma coreIso_comm_sum` at line 1143
- **Signature matches**: yes — the full alternating-coface differentials intertwined by the object isos, matching blueprint lines 8888–8894
- **Proof follows sketch**: yes — elementwise, summand-by-summand comparison via `coreIso_comm_coface` per the dead-end note; this deviates slightly from the blueprint's terse "Preadditive.comp_sum" framing but is mathematically equivalent and required by the Lean instance-path issues cited in the dead-end note
- **notes**: No `\leanok` on blueprint block — correctly absent (transitive sorry).

### `\lean{AlgebraicGeometry.abHom_finsetSum_apply}` (chapter: `lem:coreIso_comm_sum` co-pin)
- **Lean target exists**: partial — the declaration exists at line 33 but is declared `private`; the name `AlgebraicGeometry.abHom_finsetSum_apply` is **not accessible** externally (private declarations get mangled names in Lean 4)
- **Signature matches**: N/A (declaration cannot be looked up by the blueprint's `\lean{}` pin)
- **Proof follows sketch**: N/A
- **notes**: The `\lean{}` pin `AlgebraicGeometry.abHom_finsetSum_apply` in the blueprint is unreachable. `sync_leanok` would fail to verify this pin. The declaration's comment says it is a "local copy" of the `CechAcyclic` private helper; it should either be kept private with the blueprint pin removed, or promoted to non-private if independently useful.

### `\lean{AlgebraicGeometry.coreIso_comm}` (chapter: `lem:coreIso_comm`)
- **Lean target exists**: yes — `lemma coreIso_comm` at line 1281
- **Signature matches**: yes — the differential intertwining across `(ComplexShape.up ℕ).Rel i j` indices, matching blueprint lines 8916–8924
- **Proof follows sketch**: yes — `coreIso_comm_sum` + `CochainComplex.of_d` rewrite, as described in blueprint lines 8930–8937
- **notes**: **`\leanok` present** on blueprint block (line 8911), but `coreIso_comm` transitively depends on `pushPull_interLegHom_sections := sorry` through the chain `coreIso_comm_sum → coreIso_comm_coface → coreIso_comm_leg → pushPull_interLegHom_sections`. The `\leanok` marker is stale. `sync_leanok` should remove it if it checks axioms (`#print axioms` would reveal `sorryAx`).

---

## Red Flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.pushPull_interLegHom_sections` at line 1003: body is `:= sorry`. The blueprint's proof of `lem:coreIso_comm_leg` characterizes this step as "the evaluated Čech-nerve coface acts on sections as the F-restriction" — substantive content, not a trivially-true claim.

### Stale blueprint markers

- `lem:coreIso_comm` carries `\leanok` (blueprint line 8911), but `coreIso_comm` has a transitive sorry via `pushPull_interLegHom_sections`. The `\leanok` should be removed. (The three intermediate lemmas `lem:coreIso_comm_leg/coface/sum` correctly lack `\leanok`.)

---

## Unreferenced declarations (informational)

The following non-private declarations in the file have **no** `\lean{...}` block in the blueprint:

| Declaration | Line | Character |
|---|---|---|
| `backboneIncl` | 60 | def — `τ`-summand inclusion into the degree-`p` Čech backbone |
| `pushPull_sigma_iso_π_incl` | 71 | lemma — thin rephrasing of `pushPull_sigma_iso_π`; helper only |
| `backboneProj` | 81 | def — `l`-th wide-pullback projection of the backbone |
| `backbone_hom_ext` | 90 | lemma — unique-determination of backbone morphisms |
| `nerveδ_backboneProj` | 101 | lemma — nerve coface intertwines backbone projections |
| `cechNerve_drop_δ` | 112 | lemma — evaluated Čech coface is pushPull of geometric face |
| `coverInterToMember` | 119 | def — lift of intersection-open inclusion to the `τl`-th member |
| `coverInterToMember_fac` | 127 | lemma — factorization property |
| `interProj` | 134 | def — canonical `l`-th component map |
| `over_hom_ext_mono` | 145 | lemma — mono-target rigidity in the slice |
| `backboneIncl_proj` | 739 | **key non-helper lemma** — the "Stub-1 unwinding": backbone inclusion followed by wide-pullback projection is `interProj` |
| `backboneIncl_nerveδ` | 863 | **key non-helper lemma** — per-leg coface factorization of the backbone inclusion |
| `interLegHom` | 684 | def — face morphism between intersection-open legs |
| `interLegHom_interProj` | 695 | lemma — face morphism intertwines canonical component maps |
| `coreIso_objIso_π` | 908 | **key non-helper lemma** — coordinate formula for the degreewise object iso |
| `GVΨ_map_eq` | 883 | abbrev/lemma — definitional adapter |
| `pushPull_interLegHom_sections` | 1003 | **substantive lemma with sorry** — no blueprint block |
| `sectionFunctorV` | 876 | abbrev — local alias for section-at-V functor |

All entries in `section WPCIproj` (lines 156–659) are `private` and acceptable as helpers.
`entry_chain` (line 663) and `glue_chain` (line 671) are `private` helpers for the Stub-1 assembly.
`coverArrowIncl` (715), `coverReindexHom` (721), `pushPullLegIso` (957), `pushPull_leg_coherence` (974), `map_op_eqToHom_swap` (1017) are all `private` helpers — acceptable.

**Notable coverage-debt declarations** (substantive, public, no blueprint block): `backboneIncl_proj`, `backboneIncl_nerveδ`, `coreIso_objIso_π`, `pushPull_interLegHom_sections`.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 blueprint-referenced Lean declarations exist with matching signatures. Additionally `abHom_finsetSum_apply` is referenced but is private (see red flags). Unreferenced substantive declarations: `backboneIncl_proj`, `backboneIncl_nerveδ`, `coreIso_objIso_π`, `pushPull_interLegHom_sections` — 4 public non-helper declarations with no `\lean{...}` block.

- **Proof-sketch depth**: **under-specified**. The chapter provides adequate sketches for `lem:coreIso_comm_leg` through `lem:coreIso_comm` at the high level, but is **silent** on how to prove `pushPull_interLegHom_sections` (per-leg restriction naturality / sheaf seam). This step requires:
  - Using `pushPullLegIso` (the local leg iso) and `pushPull_leg_coherence` (how `pushPullMap` of an `Over.homMk` factors through the restriction unit and the leg iso)
  - Naturality of the pullback-restriction iso along the open inclusion `interLegHom`
  - Showing the adjunction unit commutes with the restriction map
  
  None of this is mentioned in the blueprint. The blueprint only says "the coface acts on sections as the F-restriction" (a one-line claim with no mechanism). A prover attempting this step from the blueprint alone would be stuck.

- **Hint precision**: loose. The blueprint's `\lean{}` hints for the 4 main declarations are precise and correct. However:
  - `AlgebraicGeometry.abHom_finsetSum_apply` is wrong (private declaration, unreachable by that path)
  - `pushPull_interLegHom_sections` is not named in the blueprint at all, leaving the prover to discover the required auxiliary lemma independently

- **Generality**: matches need — no generality mismatch found.

- **Recommended chapter-side actions** (for a blueprint-writing subagent to address):
  1. **Add a dedicated block** `\label{lem:pushPull_interLegHom_sections}` / `\lean{AlgebraicGeometry.pushPull_interLegHom_sections}` with a proof sketch covering:
     - The per-leg coherence: `pushPullMap F (Over.homMk c wC)` = restriction-unit ≫ `pushPullLegIso`; instantiate at `interLegHom` to reduce to the adjunction-unit/restriction naturality square
     - The F-restriction of sections over `U_{σ'} ∩ V ⊆ U_{σ'∘δᵏ} ∩ V` recovers the inverse leg-iso post-composed with the opened pushforward — a standard open-immersion pushforward naturality step
  2. **Add blocks** for `backboneIncl_proj` (Stub-1 unwinding) and `backboneIncl_nerveδ` with their proof sketches, since these are invoked by name in `coreIso_comm_leg`'s proof
  3. **Add a block** for `coreIso_objIso_π` as the coordinate-level unpacking of `coreIso_objIso` used in `coreIso_comm_leg`
  4. **Fix** the `\lean{AlgebraicGeometry.abHom_finsetSum_apply}` pin: remove it (private lemma) or promote the declaration to non-private
  5. **Remove** the stale `\leanok` from `lem:coreIso_comm` (line 8911) — the `sync_leanok` phase should handle this automatically once `pushPull_interLegHom_sections` has a closed proof, but if the sorry persists it should not carry `\leanok`

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint silent on proof of `pushPull_interLegHom_sections` (no block, no sketch; prover cannot formalize from prose alone) | **must-fix-this-iter** |
| `\leanok` on `lem:coreIso_comm` (line 8911) while `coreIso_comm` has a transitive sorry via `pushPull_interLegHom_sections` | **major** |
| `pushPull_interLegHom_sections` (line 1003): substantive public lemma, `:= sorry`, no `\lean{...}` blueprint block | **major** |
| `coreIso_objIso_π` (line 908): key non-helper public lemma, no blueprint block | **major** |
| `abHom_finsetSum_apply` is `private` but blueprint pins it as `AlgebraicGeometry.abHom_finsetSum_apply` (unreachable) | **minor** |
| `backboneIncl_proj`, `backboneIncl_nerveδ` (lines 739, 863): key non-helper public lemmas, no blueprint blocks | **minor** |
| `interLegHom`, `interLegHom_interProj` (lines 684, 695): public defs/lemmas with no blueprint blocks | **minor** |

**Overall verdict**: The 4 blueprint-referenced Lean declarations (`coreIso_comm_leg/coface/sum/comm`) have correct signatures and proofs that follow the blueprint sketches, but the file contains one substantive sorry (`pushPull_interLegHom_sections`, line 1003) for which the blueprint provides no proof guidance — the chapter is under-specified for this critical step. Additionally the `\leanok` on `lem:coreIso_comm` is stale. — 5 declarations checked (4 blueprint-referenced + 1 sorry target), 2 major red flags, 1 must-fix blueprint adequacy failure.
