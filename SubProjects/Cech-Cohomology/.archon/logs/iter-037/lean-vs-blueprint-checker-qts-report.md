# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
037

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (Route B section, ~lines 3720–5020)

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections, ...hom, ...inv}` (lem:qcoh_iso_tilde_sections)

- **Lean target exists**: yes — all three (`qcoh_iso_tilde_sections` at line 63, `qcoh_iso_tilde_sections_hom` at line 79, `qcoh_iso_tilde_sections_inv` at line 85)
- **Signature matches**: partial — the blueprint prose states the *unconditional* quasi-coherent form ("for quasi-coherent F, F ≅ M^~"), but the Lean formalization is the *conditional* form `[IsIso F.fromTildeΓ]`. The `% NOTE` at blueprint line 3729–3736 explicitly documents this gap and states the conditional version is the building block. No `\leanok` on the statement block (correctly absent). The signatures of the simp lemmas `...hom` and `...inv` match their Lean counterparts precisely.
- **Proof follows sketch**: yes — the sketch says "the asserted iso is the inverse of the counit"; Lean body is `(asIso F.fromTildeΓ).symm`. Mathematical content matches.
- **notes**: The `\lean{...}` pin on the unconditional prose is a deliberate design choice documented by `% NOTE` — it will be upgraded automatically once `[IsQuasicoherent F] → IsIso F.fromTildeΓ` becomes an instance. The absence of `\leanok` on the statement block is correct behaviour.

---

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (lem:qcoh_iso_tilde_sections_of_presentation)

- **Lean target exists**: yes (line 72)
- **Signature matches**: yes — blueprint: "admits a global presentation → F ≅ M^~"; Lean: `(F : (Spec R).Modules) (P : F.Presentation) : F ≅ tilde (moduleSpecΓFunctor.obj F)`
- **Proof follows sketch**: yes — blueprint: "makes counit iso via Mathlib's `isIso_fromTildeΓ_of_presentation`"; Lean: `haveI := isIso_fromTildeΓ_of_presentation F P; (asIso F.fromTildeΓ).symm`
- **notes**: Statement and proof `\leanok` both present (blueprint lines 3781, 3805). Correct.

---

### `\lean{AlgebraicGeometry.free_isQuasicoherent}` (lem:free_isQuasicoherent)

- **Lean target exists**: yes (line 103, instance)
- **Signature matches**: yes — blueprint: "free O_X-module on ι generators is quasi-coherent"; Lean: `instance free_isQuasicoherent (ι : Type u) : (SheafOfModules.free.{u} (R := (Spec R).ringCatSheaf) ι).IsQuasicoherent`
- **Proof follows sketch**: yes — blueprint: "it is the sheaf tilde(R^(ι)), quasi-coherent, prop_of_iso"; Lean: `(SheafOfModules.isQuasicoherent.{u} ...).prop_of_iso (tildeFinsupp (R := R) ι) inferInstance`
- **notes**: Statement `\leanok` present (blueprint line 4372). Correct.

---

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}` (lem:exists_finite_basicOpen_subcover)

- **Lean target exists**: yes (line 150)
- **Signature matches**: yes — blueprint: "family of opens covering Spec R → finitely many fⱼ ∈ R, φ(j), with D(fⱼ) ≤ U_{φ(j)} and span{fⱼ} = ⊤"; Lean: `∃ (n : ℕ) (f : Fin n → R) (φ : Fin n → ι), (∀ j, PrimeSpectrum.basicOpen (f j) ≤ U (φ j)) ∧ Ideal.span (Set.range f) = ⊤`
- **Proof follows sketch**: yes — basis-refinement + quasicompactness of Spec R. Mathematical steps match.
- **notes**: Statement and proof `\leanok` present (blueprint lines 4394, 4423). Correct.

---

### `\lean{AlgebraicGeometry.isLocalizedModule_of_span_cover}` + 7 helpers (lem:isLocalizedModule_of_span_cover)

- **Lean target exists**: yes (main theorem at line 330; 7 private helpers at lines 208–321, all confirmed present with matching names)
- **Signature matches**: yes — blueprint matches Lean's three-clause descent for IsLocalizedModule at powers of f over a spanning family. The private helpers listed (`exists_sum_pow_eq_one`, `mem_range_of_span_pow`, `eq_zero_of_span_pow`, `map_smul_endFun`, `bump_eq`, `per_j_surj`, `per_j_eq`) all correspond to exactly the private lemmas in `section SpanCoverLocalization`.
- **Proof follows sketch**: yes — blueprint sketches the three-clause descent (map_units, surjectivity, equaliser) using partition-of-unity with uniform exponents; the Lean proof follows this exactly (the three `refine ⟨?_, ?_, ?_⟩` branches).
- **notes**: Statement block (blueprint line 4653) does **NOT** carry `\leanok`, despite the memory recording it as axiom-clean since iter-032. The `% NOTE` at line 4659–4661 says "sync_leanok resolves them as [leanok]" — this has not happened. Probable cause: sync_leanok cannot look up `private` declarations by their qualified name (`AlgebraicGeometry.exists_sum_pow_eq_one` etc.), so the multi-name `\lean{...}` list causes the entire block to fail the leanok check. This is a sync_leanok / blueprint infrastructure gap, not a Lean correctness error. Flagged as **major** (planner action needed).

---

### `\lean{AlgebraicGeometry.tilde_section_isLocalizedModule}` (lem:tilde_section_isLocalizedModule)

- **Lean target exists**: yes (line 408)
- **Signature matches**: yes — blueprint: "section-restriction Γ(Spec R, M^~) → Γ(D(f), M^~) is IsLocalizedModule at powers of f"; Lean: `IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj (tilde M)).presheaf.map (homOfLE le_top).op).hom`
- **Proof follows sketch**: yes — blueprint: "transport toOpen over D(f) along the global-sections isomorphism M ≅ Γ(⊤, M^~)"; Lean: sets `eTop := (asIso (tilde.toOpen M ⊤)).toLinearEquiv`, rewrites the restriction as `toOpen(D f) ∘ eTop⁻¹`, uses `IsLocalizedModule.of_linearEquiv_right`.
- **notes**: Statement and proof `\leanok` present (blueprint lines 3990, 4002). Correct.

---

### `\lean{AlgebraicGeometry.section_isLocalizedModule_of_isIso_fromTildeΓ}` (lem:section_isLocalizedModule_of_isIso_fromTildeGamma)

- **Lean target exists**: yes (line 441)
- **Signature matches**: yes — blueprint: "if counit isIso, section-restriction Γ(Spec R, F) → Γ(D(f), F) is IsLocalizedModule"; Lean: `[IsIso F.fromTildeΓ] → IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj F).presheaf.map ...).hom`
- **Proof follows sketch**: yes — blueprint: "conjugate tilde_section_isLocalizedModule by the F ≅ Γ(F)^~ isomorphism via naturality"; Lean implements exactly this: sets `α := qcoh_iso_tilde_sections F`, uses naturality of `β = modulesSpecToSheaf.map α.hom` to show `ρ_F = eDf⁻¹ ∘ φ`, applies `IsLocalizedModule.of_linearEquiv`.
- **notes**: Statement and proof `\leanok` present (blueprint lines 4013, 4025). Correct.

---

### `\lean{AlgebraicGeometry.section_isLocalizedModule_of_presentation}` (lem:section_isLocalizedModule_of_presentation)

- **Lean target exists**: yes (line 498)
- **Signature matches**: yes — blueprint: "global presentation → section-restriction is IsLocalizedModule"; Lean: `(P : F.Presentation) → IsLocalizedModule (Submonoid.powers f) ...`
- **Proof follows sketch**: yes — one-liner: discharge `[IsIso F.fromTildeΓ]` via `isIso_fromTildeΓ_of_presentation`, apply previous lemma.
- **notes**: Statement and proof `\leanok` present (blueprint lines 4034, 4048). Correct.

---

### `\lean{AlgebraicGeometry.qcoh_finite_presentation_cover}` (lem:qcoh_finite_presentation_cover, Route B step B1)

- **Lean target exists**: yes (line 547)
- **Signature matches**: yes — blueprint: "from [F.IsQuasicoherent] produce finite g : Fin n → R, φ : Fin n → q.I with D(g j) ≤ q.X (φ j) and span(range g) = ⊤"; Lean: `∃ (q : SheafOfModules.QuasicoherentData.{u, u, u, u} F) (n : ℕ) (g : Fin n → R) (φ : Fin n → q.I), (∀ j, PrimeSpectrum.basicOpen (g j) ≤ q.X (φ j)) ∧ Ideal.span (Set.range g) = ⊤`
- **Universe pin `QuasicoherentData.{u,u,u,u}`**: does NOT weaken the statement. The variable `R : CommRingCat.{u}` already fixes the universe; the pin ensures the quantified datum lives at the same level as `R`, which is the expected consumer form for the keystone descent. Blueprint is correctly silent on universe details.
- **Proof follows sketch**: yes — blueprint: "quasi-coherence datum gives cover, coversTop translates to ⨆ = ⊤ (fed to `exists_finite_basicOpen_subcover`)"; Lean: extracts `q` from `hF.nonempty_quasicoherentData`, calls `coversTop_iSup_eq_top` to get the lattice hypothesis, applies `exists_finite_basicOpen_subcover`.
- **notes**: Statement and proof `\leanok` present (blueprint lines 4056, 4069). Correct.

---

### `\lean{AlgebraicGeometry.qcoh_section_isLocalizedModule}` (lem:qcoh_section_isLocalizedModule, Route B keystone)

- **Lean target exists**: **no** — the declaration `qcoh_section_isLocalizedModule` is absent from `QcohTildeSections.lean`. This is correct and expected.
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A
- **notes**: The blueprint correctly marks this block `% NOTE: to-build (Route B keystone)` with no `\leanok` on statement or proof. The `\lean{...}` pin names the *intended* declaration (documenting where it will land). The `\uses` chain is honest: it references `lem:presentation_modulesRestrictBasicOpen` (B4, to-build) and `lem:section_isLocalizedModule_of_presentation` (B5, done), and the proof sketch describes the B3 dependency via B4. No false completeness claim.

---

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` (lem:isIso_fromTildeGamma_of_genSections)

- **Lean target exists**: yes (line 117)
- **Signature matches**: yes — blueprint: "σ : F.GeneratingSections, τ : (kernel σ.π).GeneratingSections → IsIso F.fromTildeΓ"; Lean matches exactly.
- **Proof follows sketch**: yes — blueprint: "bundle into F.Presentation, apply isIso_fromTildeΓ_of_presentation"; Lean: `{ generators := σ, relations := τ }` then `isIso_fromTildeΓ_of_presentation F P`.
- **notes**: Statement and proof `\leanok` present (blueprint lines 4974, 4990). Correct.

---

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` (lem:qcoh_iso_tilde_sections_of_genSections)

- **Lean target exists**: yes (line 130)
- **Signature matches**: yes — blueprint: "σ, τ → F ≅ tilde(Γ(F))"; Lean: `noncomputable def qcoh_iso_tilde_sections_of_genSections (F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : F ≅ tilde (moduleSpecΓFunctor.obj F)`
- **Proof follows sketch**: yes
- **notes**: Statement and proof `\leanok` present (blueprint lines 5000, 5013). Correct.

---

## Red flags

### Placeholder / suspect bodies
None. Every declaration in the file has a complete proof body; no `:= sorry` anywhere.

### Excuse-comments
None. The inline comments explain mathematical non-obviousness (e.g. "crucial non-circularity point" in the `Handoff` section) without excusing wrong code. The `## Handoff` section is documentation, not a code comment.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations. The file imports `classical` tactics implicitly through `Mathlib`, but no project-local axioms are introduced.

---

## Unreferenced declarations (informational)

### `coversTop_iSup_eq_top` (private, line 527)
A private helper in `section FinitePresentationCover` that translates the categorical `CoversTop` condition of a `QuasicoherentData` into the lattice-theoretic `⨆ Y i = ⊤` that `exists_finite_basicOpen_subcover` consumes. It has no `\lean{...}` reference in any blueprint block.

**Assessment of the prover's suggestion to bundle it into `lem:qcoh_finite_presentation_cover`:** Correct. The convention established for `lem:isLocalizedModule_of_span_cover` (blueprint line 4655–4661) is to list private helpers in the parent block's `\lean{...}` with a `% NOTE` comment ("carry no separate blueprint block; bundled to keep them out of leandag unmatched"). `coversTop_iSup_eq_top` is the direct analogue: it is the sole private helper of `qcoh_finite_presentation_cover`, used exclusively in that proof, and has no other consumers. Its correct home is `lem:qcoh_finite_presentation_cover`'s `\lean{...}` list.

The leandag `unmatched` coverage report will flag it until this is done. **Major** (blueprint action, not Lean correctness).

### `qcoh_iso_tilde_sections_of_presentation`'s `haveI` discharge
Helper `isIso_fromTildeΓ_of_genSections` is referenced as a wrapper lemma in the `## Handoff` section docstring but is already covered by its own blueprint block. No issue.

---

## Blueprint adequacy for this file

- **Coverage**: 13 public declarations in the file; 13 have a corresponding `\lean{...}` block. 1 private helper (`coversTop_iSup_eq_top`) is unreferenced. The 7 helpers of `isLocalizedModule_of_span_cover` are bundled in their parent block (documented convention). Coverage score: 13/13 public + 7/7 bundled helpers = full, minus 1 private outlier.
- **Proof-sketch depth**: **adequate** for the formalized declarations. The B1 sketch (blueprint lines 4067–4076) precisely maps to the Lean proof: extract datum, apply `coversTop_iSup_eq_top`, apply `exists_finite_basicOpen_subcover`. The local-model brick sketches are likewise detailed enough. The keystone sketch is appropriately aspirational (to-build) with no false completeness.
- **Hint precision**: **precise** for all formalized blocks. The `\lean{...}` pins name exactly the Lean declarations with matching signatures. The single partial case — `lem:qcoh_iso_tilde_sections` pinning the conditional form while the prose claims the unconditional — is explicitly documented via `% NOTE` and is a deliberate design decision, not a precision failure.
- **Generality**: **matches need** for the formalized blocks. The universe pin `QuasicoherentData.{u,u,u,u}` in B1 is appropriate for the project's setting and does not over-narrow.
- **`isLocalizedModule_of_span_cover` missing `\leanok`**: The `% NOTE` at blueprint line 4659 says "sync_leanok resolves them as [leanok]" but neither the statement nor proof block carries `\leanok` despite the theorem being axiom-clean since iter-032. Root cause is likely sync_leanok's inability to look up `private` declarations by qualified name (the 8-entry `\lean{...}` list includes 7 private lemmas). The planner should investigate: either fix sync_leanok to skip private-name lookup failures when the main theorem is resolved, or remove the private-helper names from the `\lean{...}` list (they are already documented as "carry no separate blueprint block"). **Major** — a proved theorem appearing unmarked can mislead the planner's completeness tracking.

- **Recommended chapter-side actions**:
  1. Add `AlgebraicGeometry.coversTop_iSup_eq_top` to the `\lean{...}` list of `lem:qcoh_finite_presentation_cover` with the comment `% NOTE: private helper bundled to avoid leandag unmatched (no separate block).`
  2. Investigate why `lem:isLocalizedModule_of_span_cover` lacks `\leanok`. If the cause is private-name lookup in sync_leanok, either fix the sync script or trim the `\lean{...}` list to the public theorem name only and move the private-helper documentation into a `% NOTE`.
  3. No other blueprint changes required this iter; the to-build markers on B3/B4/keystone are honest and complete.

---

## Severity summary

| Finding | Severity |
|---|---|
| `coversTop_iSup_eq_top` not in any `\lean{...}` — leandag coverage debt | **major** |
| `lem:isLocalizedModule_of_span_cover` missing `\leanok` despite axiom-clean Lean — sync_leanok gap | **major** |
| `lem:qcoh_iso_tilde_sections` `\lean{...}` pins conditional form vs. unconditional prose — explicitly documented via `% NOTE`, no `\leanok` absent | **minor** (documented design decision; not a mismatch in the actionable sense) |

No must-fix-this-iter findings. No fake statements, no sorries, no excuse-comments, no axioms.

**Overall verdict**: `QcohTildeSections.lean` faithfully realizes its blueprint obligations for all formalized declarations; the one open item (`qcoh_section_isLocalizedModule`) is correctly marked to-build with honest dependency tracking; two major bookkeeping gaps (missing `coversTop_iSup_eq_top` in the `\lean{...}` list, stale `\leanok` absence on `isLocalizedModule_of_span_cover`) need blueprint/infrastructure fixes but do not indicate Lean errors.
