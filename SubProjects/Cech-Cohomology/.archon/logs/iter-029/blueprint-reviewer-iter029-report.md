# Blueprint Review Report — iter-029

## Slug
iter029

## Iteration
029

## Gate target
`AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` (Tag 02KG affine Serre vanishing)

## Tool audit log

| Tool | Result |
|------|--------|
| `leandag build --json` | `unknown_uses: []` — no broken `\uses{}` edges; 1 isolated node (type `lean_aux`); many `unmatched_lean` entries for `\mathlibok` nodes and unformalized decls (expected) |
| `archon blueprint-doctor --json` | clean — no `malformed_refs`, no `broken_refs`, no `orphan_chapters` |
| `leandag show isolated` | 1 node, type `lean_aux`; disposition: keep (uncovered Lean helper, normal) |

---

## Per-chapter audit

### Chapter 1 — `Cohomology_HigherDirectImage.tex`

```
complete: true
correct:  true
```

**Checklist**

- [x] All declared lemmas/defs carry `\lean{...}`
- [x] All formalized blocks carry `\leanok`
- [x] `\uses{}` graph edges reference existing labels (leandag confirms)
- [x] Source citations point to files present in `references/`
- [x] `[HasInjectiveResolutions X.Modules]` hypothesis properly disclosed in NOTE comment

**Notes**

Single declaration chapter — `def:higher_direct_image` with `\lean{AlgebraicGeometry.higherDirectImage}` and `\leanok`. The NOTE correctly explains the hypothesis is conditional and can be dropped once a lane proves the Grothendieck-abelian instance. No findings.

---

### Chapter 2 — `Cohomology_AcyclicResolution.tex`

```
complete: true
correct:  true
```

**Checklist**

- [x] All declared lemmas/defs carry `\lean{...}`
- [x] All formalized blocks carry `\leanok` (full chapter closed)
- [x] `\uses{}` graph edges reference existing labels
- [x] Source citations reference `homological-acyclic-derived.tex` / `homological-acyclic-homology.tex` (files present in `references/`)
- [x] Proof sketches adequate — each block traces Stacks tags 0157/015C/015E/05TA with verbatim quotes

**Notes**

No findings. Chapter is fully formalized.

---

### Chapter 3 — `Cohomology_CechHigherDirectImage.tex`

```
complete: true
correct:  true
```

**Checklist: `def:basis_cov_system` reconciliation (iter-029 focus item)**

- [x] Prose lists exactly 5 fields: `B` (basis), `Cov` (CovDatum), `faces_mem`, `surj_of_vanishing`, `injective_acyclic`
- [x] `surj_of_vanishing` correctly described as the section-surjectivity OUTPUT (not raw cofinality): "for every covering family `U ∈ Cov`, the section map H⁰(U,F)→H⁰(U,I) is surjective whenever F→I is injective"
- [x] `injective_acyclic` correctly described as Čech-vanishing for injective sheaves: "for every injective sheaf I and every U ∈ Cov, Ȟⁿ(U,I) = 0 for n ≥ 1"
- [x] `\lean{AlgebraicGeometry.BasisCovSystem, AlgebraicGeometry.CovDatum}` present
- [x] `[EnoughInjectives X.Modules]` disclosure added to `lem:absolute_cohomology_pos_vanishing`, `lem:cech_to_cohomology_on_basis`, `lem:affine_serre_vanishing` (three lemmas that carry the hypothesis)

**Checklist: eight new 02KG sub-lemmas**

| Decl | `\lean{}` | `\uses{}` acyclic | Source file on disk | Proof sketch adequate | Status |
|------|-----------|-------------------|---------------------|-----------------------|--------|
| `lem:affine_faces_mem` | `AlgebraicGeometry.affine_faces_mem` | ✓ | `stacks-schemes.tex` (`lemma-standard-open`) | ✓ D(f)∩D(g)=D(fg) elementary | READY |
| `lem:standard_cover_cofinal` | present | ✓ | `stacks-schemes.tex` + `stacks-sheaves.tex` (Tag 009L) | ✓ two sources cited | READY *(see INFO-2)* |
| `lem:affine_surj_of_vanishing` | present | ✓ (`ses_cech_h1`, `standard_cover_cofinal`) | `stacks-cohomology.tex` (`lemma-ses-cech-h1`) | ✓ | READY |
| `lem:cover_datum_bridge` | present | ✓ (no external source — project-bespoke) | — | ✓ identification of CovDatum Čech with open-cover Čech | READY |
| `lem:affine_injective_acyclic` | present | ✓ (`injective_cech_acyclic`, `cover_datum_bridge`) | `stacks-cohomology.tex` (`lemma-injective-trivial-cech`) | ✓ | READY |
| `def:affine_cover_system` | `AlgebraicGeometry.affineCoverSystem` | ✓ (three preceding lemmas) | Tag 02KG proof in `stacks-coherent.tex` | ✓ bundles B=distinguished opens, Cov=standard covers | READY |
| `lem:qcoh_iso_tilde_sections` | `AlgebraicGeometry.qcoh_iso_tilde_sections` | ✓ (`def:standard_affine_cover`) | `stacks-schemes.tex` Tag 01HV + Tag 01I8 | thin *(see INFO-1)* | READY |
| `lem:affine_cech_vanishing_qcoh` | present | ✓ (`cech_acyclic_affine`, `qcoh_iso_tilde_sections`, `affine_cover_system`, `has_vanishing_higher_cech`) | stacks-coherent.tex | ✓ assembles HasVanishingHigherCech seed | READY |

**Checklist: top `lem:affine_serre_vanishing`**

- [x] `\lean{AlgebraicGeometry.affine_serre_vanishing}` present
- [x] `\uses{def:affine_cover_system, lem:affine_cech_vanishing_qcoh, lem:cech_to_cohomology_on_basis, def:absolute_cohomology}` — all four targets exist; leandag confirms no broken edges
- [x] `[EnoughInjectives X.Modules]` carried as explicit hypothesis
- [x] Source Tag 02KG (`lemma-quasi-coherent-affine-cohomology-zero`) in `stacks-coherent.tex`
- [x] Proof sketch routes through `cech_to_cohomology_on_basis` (01EO, already `\leanok`) applied to `affineCoverSystem`
- [ ] Opening sentence of `% SOURCE QUOTE:` block may be editorial, not verbatim *(see INFO-4)*

**Checklist: downstream lemmas consuming `lem:affine_serre_vanishing`**

- [x] `lem:open_immersion_pushforward_comp` — `\uses{lem:affine_serre_vanishing, lem:higher_direct_image_presheaf}` — correct dependency; relative affine vanishing route
- [x] `lem:cech_term_pushforward_acyclic` — `\uses{..., lem:open_immersion_pushforward_comp}` — correct; acyclicity of Čech terms
- [x] `lem:cech_computes_cohomology` — top theorem, `\leanok` (closed iter-028)

**Notes**

No must-fix findings. Four informational notes follow.

---

## Findings

### INFO-1 — `lem:qcoh_iso_tilde_sections`: proof sketch thin (not blocking)

**File**: `Cohomology_CechHigherDirectImage.tex` line ~3409  
**Severity**: INFO  
**Description**: The proof sketch for `lem:qcoh_iso_tilde_sections` (the 01I8 affine equivalence `F ≅ ~(ΓF)` for qcoh F on Spec R) says "apply `isIso_fromTildeΓ_of_presentation`" without detailing the intermediate steps. The lemma is mathematically correct and the Mathlib entry point is correctly named. STRATEGY.md explicitly marks 01I8 globalisation as "NOW DUE as part of 02KG."  
**Action**: The prover for `AffineSerreVanishing.lean` must consult `AlgebraicGeometry.Modules.Tilde` and the `isIso_fromTildeΓ_of_presentation` infrastructure. The blueprint need not be amended before dispatch — the prover brief should mention this thin sketch.

---

### INFO-2 — `lem:standard_cover_cofinal`: source-quote ordering anomaly (not blocking)

**File**: `Cohomology_CechHigherDirectImage.tex` line ~3234  
**Severity**: INFO  
**Description**: The block has two `% SOURCE:` lines but the first `% SOURCE QUOTE:` appears between them rather than immediately after its source. Specifically: `% SOURCE: stacks-schemes.tex ... % SOURCE QUOTE: (quote A) % SOURCE: stacks-sheaves.tex ... % SOURCE QUOTE: (quote B)`. Both referenced files exist and both verbatim quotes are appropriate to their respective sources. The ordering is non-standard per project convention but not erroneous.  
**Action**: Optional cleanup — reorder so each `% SOURCE QUOTE:` immediately follows its `% SOURCE:`. Not required before dispatch.

---

### INFO-3 — one isolated `lean_aux` node (expected)

**Tool**: `leandag show isolated`  
**Severity**: INFO  
**Description**: `leandag` reports 1 isolated node of type `lean_aux`. This is an uncovered Lean helper declaration — a project-standard artifact.  
**Action**: None. Keep.

---

### INFO-4 — `lem:affine_serre_vanishing` source quote opening sentence (citation-discipline note)

**File**: `Cohomology_CechHigherDirectImage.tex` line ~3127  
**Severity**: INFO (low)  
**Description**: The `% SOURCE QUOTE:` block for `lem:affine_serre_vanishing` opens with a sentence of the form "Serre vanishing: Higher cohomology vanishes on affine schemes for quasi-coherent modules." This reads like an editorial descriptor rather than a verbatim sentence from Stacks `lemma-quasi-coherent-affine-cohomology-zero` (Tag 02KG). The actual Stacks lemma statement begins differently. Cannot confirm without reading `stacks-coherent.tex` at the precise line, but the discrepancy is plausible.  
**Action**: Low-priority. Prover dispatch is not blocked. Review agent or plan agent should verify against `references/stacks-coherent.tex` and correct to verbatim if it is indeed paraphrased.

---

## Severity summary

| Severity | Count | Items |
|----------|-------|-------|
| MUST-FIX-THIS-ITER | 0 | — |
| WARN | 0 | — |
| INFO | 4 | INFO-1 through INFO-4 (all non-blocking) |

**Unstarted-phase proposals**: 0

**leandag health**: `unknown_uses: []`, 1 lean_aux isolated node (expected)  
**blueprint-doctor health**: clean

---

## Hard gate verdict

**CLEARS.**

All three chapters are `complete: true · correct: true`. The nine new 02KG declarations (`lem:affine_faces_mem`, `lem:standard_cover_cofinal`, `lem:affine_surj_of_vanishing`, `lem:cover_datum_bridge`, `lem:affine_injective_acyclic`, `def:affine_cover_system`, `lem:qcoh_iso_tilde_sections`, `lem:affine_cech_vanishing_qcoh`, `lem:affine_serre_vanishing`) are all FORMALIZE-READY:

- Statements well-formed and mathematically faithful
- `\lean{}` name pins present for all targets
- `\uses{}` graph is acyclic with no broken edges (leandag `unknown_uses: []`)
- Source citations reference files present in `references/`
- Proof sketches sufficient for piece-by-piece prover construction (modulo the known-thin 01I8 sketch flagged in INFO-1)
- `def:basis_cov_system` prose matches the 5-field Lean encoding

**`AffineSerreVanishing.lean` may be dispatched to a prover.**

Prover briefing note: the thinest path is `affineCoverSystem` → `cech_to_cohomology_on_basis` (already `\leanok`) → `affine_serre_vanishing`. The hardest single block inside that path is `qcoh_iso_tilde_sections` (the 01I8 tilde-sections bridge); prover should start with `AlgebraicGeometry.Modules.Tilde.isIso_fromTildeΓ_of_presentation`.

---

iter029: CLEARS — 3 chapters audited, 4 findings (all INFO), 0 unstarted-phase proposals
