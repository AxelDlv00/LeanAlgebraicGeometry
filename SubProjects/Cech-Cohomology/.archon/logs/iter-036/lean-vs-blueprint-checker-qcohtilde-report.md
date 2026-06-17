# Lean ↔ Blueprint Check Report

## Slug
qcohtilde

## Iteration
036

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (blueprint-referenced declarations only)

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections, qcoh_iso_tilde_sections_hom, qcoh_iso_tilde_sections_inv}` (chapter: `lem:qcoh_iso_tilde_sections`, L3750)
- **Lean target exists**: yes — all three at L63–87
- **Signature matches**: yes (conditional `[IsIso F.fromTildeΓ]` form, as expected; the chapter NOTE at L3754 explicitly documents the conditional form)
- **Proof follows sketch**: yes — `qcoh_iso_tilde_sections` is `(asIso F.fromTildeΓ).symm`, matching the "inverse of the counit" sketch; simp lemmas are trivially correct
- **notes**: `\leanok` absent from the statement block (L3749–3753); proof block has `\leanok` only on `qcoh_iso_tilde_sections_of_presentation` (separate block). This appears to be a `sync_leanok` issue, not a formalization issue.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (chapter: `lem:qcoh_iso_tilde_sections_of_presentation`, L3809)
- **Lean target exists**: yes — L72–75
- **Signature matches**: yes (`F.Presentation → F ≅ tilde (moduleSpecΓFunctor.obj F)`)
- **Proof follows sketch**: yes — uses `isIso_fromTildeΓ_of_presentation` then `(asIso F.fromTildeΓ).symm`, matching the sketch
- **notes**: Statement and proof blocks have `\leanok`. Clean.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_presentation}` (chapter: `lem:isIso_fromTildeGamma_of_presentation`, L3843)
- **Lean target exists**: Mathlib-provided; used directly via `isIso_fromTildeΓ_of_presentation` (imported from `Mathlib.AlgebraicGeometry.Modules.Tilde`). `\mathlibok` set. ✓
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib)

### `\lean{AlgebraicGeometry.free_isQuasicoherent}` (chapter: `lem:free_isQuasicoherent`, L4136)
- **Lean target exists**: yes — L103–106
- **Signature matches**: yes (`instance free_isQuasicoherent (ι : Type u) : (SheafOfModules.free (R := ...) ι).IsQuasicoherent`)
- **Proof follows sketch**: yes — uses `prop_of_iso` + `tildeFinsupp`, matching the "tilde of free R-module" description
- **notes**: Statement block has `\leanok`. Clean.

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}` (chapter: `lem:exists_finite_basicOpen_subcover`, L4158)
- **Lean target exists**: yes — L150–186
- **Signature matches**: yes (cover `U : ι → Opens X` with `⊔ U = ⊤` → finite `f, φ` with containment + unit-ideal-span)
- **Proof follows sketch**: yes — basis refinement + quasicompactness extraction, matching the proof sketch
- **notes**: Statement and proof blocks have `\leanok`. Clean.

### `\lean{AlgebraicGeometry.isLocalizedModule_of_span_cover, AlgebraicGeometry.exists_sum_pow_eq_one, ..., AlgebraicGeometry.per_j_eq}` (chapter: `lem:isLocalizedModule_of_span_cover`, L4416)
- **Lean target exists**: yes for the main theorem (`isLocalizedModule_of_span_cover`, L330–378); the seven helpers (`exists_sum_pow_eq_one`, `mem_range_of_span_pow`, `eq_zero_of_span_pow`, `map_smul_endFun`, `bump_eq`, `per_j_surj`, `per_j_eq`) are all present (L207–321)
- **Signature matches**: yes for the main theorem; helpers also match the blueprint prose
- **Proof follows sketch**: yes — the three defining clauses of `IsLocalizedModule` are verified by descent along the spanning cover, exactly as described
- **notes**: **[Minor]** All seven helpers are declared `private` in the Lean file. The blueprint's `\lean{}` pin lists them as `AlgebraicGeometry.exists_sum_pow_eq_one` etc., but `private` declarations cannot be referenced by their fully-qualified name from outside the file. `sync_leanok` will fail to verify these names. The main theorem name is correct and public. Recommend either making the helpers non-private (if they are meant to be blueprint-documented) or dropping them from the `\lean{}` pin and noting them as internal helpers only.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` (chapter: L4735)
- **Lean target exists**: yes — L117–121
- **Signature matches**: yes (`F.GeneratingSections → (kernel σ.π).GeneratingSections → IsIso F.fromTildeΓ`)
- **Proof follows sketch**: yes — bundles two generating families into `F.Presentation`, feeds to `isIso_fromTildeΓ_of_presentation`
- **notes**: Clean.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` (chapter: L4761)
- **Lean target exists**: yes — L130–134
- **Signature matches**: yes (same two `GeneratingSections` inputs → iso)
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.qcoh_section_isLocalizedModule}` (chapter: `lem:qcoh_section_isLocalizedModule`, L3929)
- **Lean target exists**: **no** — not yet formalized. The blueprint pin has an explicit `% NOTE: to-build` annotation (L3932–3935), marking it as a frontier target. This is expected and not a red flag.
- **Signature matches**: N/A (frontier)
- **Proof follows sketch**: N/A (frontier)
- **notes**: Blueprint declares this as to-build with an accurate description of the intended signature.

---

## Red flags

### Placeholder / suspect bodies
_None._ Every declaration in the Lean file has a complete proof body. No `:= sorry`, `:= True`, or suspicious triviality found.

### Excuse-comments
_None._ The `## Handoff` section (L508–553) describes the remaining mathematical gap in standard "proof obligation" language (not excusing incomplete code). It is an appropriate engineering comment about a known frontier.

### Axioms / Classical.choice on substantive claims
_None found._ The file imports `Classical` implicitly via Mathlib but makes no `axiom` declarations.

---

## Unreferenced declarations (coverage debt — the three new iter-036 lemmas)

The following three substantive declarations were added this iter and have **no** dedicated `\lean{...}` pin in the blueprint:

| Lean declaration | Line | Informal role |
|---|---|---|
| `tilde_section_isLocalizedModule` | L408 | Route B local model — pure tilde case: `IsLocalizedModule (powers f)` for section-restriction of `M^~` |
| `section_isLocalizedModule_of_isIso_fromTildeΓ` | L441 | Route B local model — counit-iso case: transport to arbitrary `F` where `IsIso F.fromTildeΓ` |
| `section_isLocalizedModule_of_presentation` | L498 | Route B local model — presentation case: discharge via `isIso_fromTildeΓ_of_presentation` |

These are the **load-bearing local model bricks** that the keystone `qcoh_section_isLocalizedModule` will descend over its trivialising cover. They are mathematically substantive (non-trivial proofs, not helpers) and are exactly the kind of declarations the blueprint should reference with `\lean{}` pins.

**[Major]** The blueprint provides no `\lean{}` pin for any of the three. The informal role is described only diffusely in the Route B section introduction (L3852–3872) and in the proof sketch for `lem:qcoh_section_isLocalizedModule` (L3967–3988), but without dedicated lemma blocks.

---

## Lean → Blueprint consistency check: three new lemmas vs. blueprint route

**Do the three new lemmas faithfully realize the blueprint route?** Yes, with the following correspondence:

1. **`tilde_section_isLocalizedModule`** (L408): The blueprint proof sketch for `lem:qcoh_section_isLocalizedModule` says "For a free O-module the section-restriction over a distinguished open is the structure-sheaf localization (tilde(-).toOpen is an IsLocalizedModule at the powers of the defining element)." `tilde_section_isLocalizedModule` implements precisely this for an arbitrary `R`-module `M` (not just free), using `tilde.toOpen_res` + `tilde.isoTop` to transport along the global-sections isomorphism. This is a faithful and slightly more general version of the blueprint step.

2. **`section_isLocalizedModule_of_isIso_fromTildeΓ`** (L441): The blueprint sketch says "The identification of F|_{D(g_j)} with tilde(M_j) is obtained from the local presentation by tilde(-) being right-exact... With F|_{D(g_j)} ≅ tilde(M_j) in hand, Tag 01HV(4) gives Γ(D(f) ∩ D(g_j), F) = (M_j)_f." `section_isLocalizedModule_of_isIso_fromTildeΓ` formalizes the consequence: if the counit is iso (equivalently F ≅ tilde(M)), transport `tilde_section_isLocalizedModule` via naturality of the section-restriction under `modulesSpecToSheaf`. This faithfully encodes the "with F ≅ tilde(M) in hand" step.

3. **`section_isLocalizedModule_of_presentation`** (L498): The presentation-driven discharge corresponds to the blueprint's "local presentation by tilde(-) being right-exact" giving a `Presentation` on each affine piece. Faithful.

**Divergence from blueprint sketch route**: The blueprint proof sketch at L3982-3988 says Čech acyclicity (`lem:cech_acyclic_affine`) is used "only to patch the global sections Γ(X,F) and Γ(D(f),F) from the per-g_j pieces," while `isLocalizedModule_of_span_cover` handles the descent. In the actual Lean bricks, the three new lemmas work directly on the full section-restriction `Γ(Spec R, F) → Γ(D(f), F)` (not localized per-piece): they show this map itself is `IsLocalizedModule` when `IsIso F.fromTildeΓ` holds globally. The per-piece application to a quasi-coherent F requires localizing the situation at each `g_j` — i.e., transporting F to an affine `Spec R_{g_j}` and applying the lemma there. **This geometric base-change step (`D(g_j) ≅ Spec R_{g_j}`) is absent from both the Lean file and the blueprint sketch** (see Blueprint → Lean adequacy section below). Čech acyclicity, as mentioned in the sketch, may or may not be needed depending on how the per-piece identification is organized; the current Lean bricks do not use it.

---

## Blueprint → Lean adequacy for this file

- **Coverage**: 8/11 Lean declarations have a corresponding `\lean{...}` block. 3 substantive declarations are unreferenced (see above).
- **Proof-sketch depth**: **under-specified** for the frontier keystone `lem:qcoh_section_isLocalizedModule`.
- **Hint precision**: **loose** for `lem:qcoh_section_isLocalizedModule` and its three new local-model prerequisites (no \lean{} pins for the new lemmas).
- **Generality**: matches need for all formalized blocks. The new local-model lemmas work at the right level of generality.

### Critical adequacy gap: the geometric base-change bridge

**[Major]** The proof sketch for `lem:qcoh_section_isLocalizedModule` (L3957–3995) describes the per-piece step as "Fix j and localize the situation at g_j." This requires transporting F from `Spec R` to `D(g_j) ≅ Spec R_{g_j}` — the "modules restrict to basic-open" bridge (`lem:modules_restrict_basicOpen`, formalized in `QcohRestrictBasicOpen.lean`). The blueprint proof sketch does NOT name this bridge. It says the identification of F|_{D(g_j)} ≅ tilde(M_j) comes from "right-exactness of tilde," but right-exactness of tilde can only be invoked *on Spec R_{g_j}* (after the base-change), not directly on Spec R.

Concretely: to apply `section_isLocalizedModule_of_presentation` (or `section_isLocalizedModule_of_isIso_fromTildeΓ`) on the piece D(g_j), the prover needs F|_{D(g_j)} as an O_{Spec R_{g_j}}-module with an R_{g_j}-module Presentation. This is exactly the content of `lem:modules_restrict_basicOpen` (the `.over`→affine base-change bridge reported by the prover as the gap). The blueprint's `\uses{}` block for `lem:qcoh_section_isLocalizedModule` (L3958–3959) does **not** include `lem:modules_restrict_basicOpen`.

The prover (correctly) identified this missing bridge as the sole remaining blocker. The blueprint sketch glosses over it with "localize the situation at g_j" in one clause, giving no formal lemma reference and no indication of the mechanism or effort involved. A prover working from the blueprint sketch alone could not formalize the keystone without independently discovering this gap.

**Consequence**: The blueprint's proof sketch for `lem:qcoh_section_isLocalizedModule` cannot guide a prover to closure without additional elaboration of step 2 ("Fix j and localize at g_j"). The missing ingredient is the affine base-change bridge. The `\uses{}` block should include `lem:modules_restrict_basicOpen`.

### Blueprint → Lean: `lem:cech_acyclic_affine` in \uses{} may be spurious for Route B

The blueprint lists `lem:cech_acyclic_affine` in the \uses{} block for `lem:qcoh_section_isLocalizedModule`. The Lean approach with `isLocalizedModule_of_span_cover` does not obviously require Čech acyclicity — `isLocalizedModule_of_span_cover` descends directly from per-cover-element `IsLocalizedModule` data. Whether Čech acyclicity is needed to avoid circularity in establishing `Γ(X,F)_{g_j} ≅ Γ(D(g_j),F)` (without invoking `qcoh_section_isLocalizedModule` for g_j circularly) is a design question the blueprint sketch does not resolve. This is an **informational** concern about potential \uses{} inflation; it does not affect current formalization.

### Recommended chapter-side actions

1. **Add three dedicated blueprint blocks** for `tilde_section_isLocalizedModule`, `section_isLocalizedModule_of_isIso_fromTildeΓ`, and `section_isLocalizedModule_of_presentation` with `\lean{}` pins. These are the per-piece local model bricks of the Route B keystone and belong in the blueprint's Route B section (between the Mathlib helper blocks and `lem:qcoh_section_isLocalizedModule`).

2. **Add `lem:modules_restrict_basicOpen` to the `\uses{}` block** of `lem:qcoh_section_isLocalizedModule` (both statement and proof), and **expand the proof sketch** to explicitly name the step "restrict F to D(g_j) as an O_{Spec R_{g_j}}-module via `lem:modules_restrict_basicOpen`, then invoke `section_isLocalizedModule_of_presentation` there." Without this, the sketch cannot guide the keystone formalization.

3. **Fix `\lean{}` pin for private helpers**: Remove `AlgebraicGeometry.exists_sum_pow_eq_one` and the six other private helpers from the `isLocalizedModule_of_span_cover` `\lean{}` list (or add a `% NOTE: private helpers, not externally verifiable` annotation). Only `AlgebraicGeometry.isLocalizedModule_of_span_cover` (public) should be in the pin.

---

## Severity summary

| Finding | Severity |
|---|---|
| `tilde_section_isLocalizedModule` has no blueprint `\lean{}` pin | **major** |
| `section_isLocalizedModule_of_isIso_fromTildeΓ` has no blueprint `\lean{}` pin | **major** |
| `section_isLocalizedModule_of_presentation` has no blueprint `\lean{}` pin | **major** |
| Blueprint proof sketch for `lem:qcoh_section_isLocalizedModule` glosses over the geometric base-change bridge (`lem:modules_restrict_basicOpen`), which is the sole remaining blocker for the keystone — a prover cannot close the keystone from the sketch alone | **major** |
| Private helpers listed under `lem:isLocalizedModule_of_span_cover` \lean{} pin are not publicly verifiable | **minor** |

**Overall verdict**: The Lean file is axiom-clean with no placeholders or excuse-comments; the three new iter-036 lemmas faithfully implement the Route B local model route described in the blueprint. The findings are coverage gaps: three substantive lemmas lack `\lean{}` pins (major × 3), and the blueprint proof sketch for the frontier keystone is under-specified about the geometric base-change step that the prover correctly identified as the blocker (major × 1).
