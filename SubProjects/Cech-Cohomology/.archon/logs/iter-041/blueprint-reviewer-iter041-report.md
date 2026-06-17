# Blueprint Review Report

## Slug
iter041

## Iteration
041

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_section_isLocalizedModule`: The descent step
  "under the section comparison this is exactly the statement that the gⱼ-localized section map
  (ρ_f)_{g_j} : Γ(X,F)_{g_j} → Γ(D(f),F)_{g_j} satisfies IsLocalizedModule(powers f)" is not
  supported by any cited lemma. `lem:section_isLocalizedModule_of_presentation` applied to F_{(g_j)}
  on Spec R_{g_j} gives that `Γ(D(g_j),F) → Γ(D(fg_j),F)` is IsLocalizedModule(powers f) (via
  `lem:restrict_obj_mathlib`'s definitional equality). But `lem:isLocalizedModule_of_span_cover`
  requires `(ρ_f)_{g_j} : Γ(X,F)_{g_j} → Γ(D(f),F)_{g_j}` — a map between abstract R-module
  localizations, not between sections over opens. Bridging them requires `Γ(D(g_j),F) ≅ Γ(X,F)_{g_j}`
  (sheaf-gluing/Čech-H⁰), which is (a) the keystone for f replaced by g_j (circular) or (b) an
  unstated supporting sub-lemma. Neither `lem:restrict_obj_mathlib` nor anything else in the `\uses`
  list supplies this identification. STRATEGY.md § "KEYSTONE descent non-circularity (NEW, iter-041,
  load-bearing)" confirms the gap is live and unresolved.

### Dependency & isolation findings

- `lean_aux` node (no chapter, ID `lean:Alg…`): isolated, 0 edges, 0 impact. **Disposition: keep.**
  Uncovered Lean helper with no blueprint block; not a blueprint gap. No writer action needed.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: partial
- **correct**: partial
- **notes**:

  **B3b (`lem:restrict_over_compat`) — PASS after iter-041 edits.**
  Statement correctly describes `engine.inverse.obj(F.over D(g)) ≅ F.restrict ι` in
  D̂(g).Modules, matching the actual Lean decl `overBasicOpenIsoRestrict`. Stale
  `% NOTE: SCOPE MISMATCH` was removed. `\lean{AlgebraicGeometry.overBasicOpenIsoRestrict}` is
  accurate. `\uses` (statement: `def:modules_over_basicOpen_equivalence`,
  `lem:modules_restrict_basicOpen`, `lem:pushforwardPushforwardEquivalence_mathlib`,
  `lem:restrict_obj_mathlib`; proof adds `lem:overEquivalence_isContinuous`) is accurate. Proof
  prose covers B3a (structure-sheaf compatibility) and B3b (module equivalence on subspace) with
  adequate detail. B3c affine transport correctly deferred to B4. No issues.

  **B4 (`lem:presentation_modulesRestrictBasicOpen`) — PASS after iter-041 edits.**
  `\lean{}` now bundles `presentationModulesRestrictBasicOpen`, `restrictBasicOpenUnitIso`,
  `pullbackObjUnitToUnit_isIso_basicOpen`. `\uses` gained `def:modules_over_basicOpen_equivalence`.
  Proof prose correctly chains: B2 (present F.over D(g_j)) → engine inverse → B3b bridge
  (`lem:restrict_over_compat`, `lem:presentation_ofIsIso_mathlib`) → B3c affine transport (D(g) ≅
  Spec R_g isomorphism, unit compatibility). No issues.

  **MUST-FIX: `lem:qcoh_section_isLocalizedModule` — proof sketch has an unjustified descent step.**
  Statement, `\lean{}` hint, and overall route description are correct. The `\uses` block (statement
  and proof both list: `lem:isLocalizedModule_of_span_cover`, `lem:exists_finite_basicOpen_subcover`,
  `lem:qcoh_finite_presentation_cover`, `lem:presentation_modulesRestrictBasicOpen`,
  `lem:section_isLocalizedModule_of_presentation`) does not include any lemma establishing
  `Γ(D(g_j),F) ≅ Γ(X,F)_{g_j}` as R-modules.

  The precise gap: `lem:section_isLocalizedModule_of_presentation` on F_{(g_j)} (globally presented
  on Spec R_{g_j}) gives `IsLocalizedModule(powers f) (Γ(D(g_j),F) → Γ(D(fg_j),F))` — via
  `lem:restrict_obj_mathlib`'s sectionwise definitional equality `Γ(F_{(g_j)}, V) = Γ(F, ι(V))`.
  But `lem:isLocalizedModule_of_span_cover` (step B6) takes M = Γ(X,F), N = Γ(D(f),F), and
  requires `IsLocalizedModule(powers f) ((ρ_f)_{g_j} : M_{g_j} → N_{g_j})` — i.e., the
  LOCALIZED MAPS between abstract R-module localizations, not section maps between open-restriction
  groups. The proof text's phrase "under the section comparison this is exactly the statement …"
  asserts the identification `Γ(D(g_j),F) ≅ Γ(X,F)_{g_j}` and `Γ(D(fg_j),F) ≅ Γ(D(f),F)_{g_j}`
  as a byproduct of `lem:restrict_obj_mathlib`, but `lem:restrict_obj_mathlib` only gives the
  definitional sectionwise equality; it does NOT give the abstract module localization
  identification.

  To close the gap, the blueprint needs either:
  (a) A new sub-lemma `Γ(D(g_j),F) ≅ Γ(X,F)_{g_j}` proved non-circularly before invoking the
      descent — STRATEGY.md proposes reusing P3 `exact_of_isLocalized_span` / sectionCech H⁰ on
      the cover (with each F_{(g_j)} tile-structured via B4 ⟹ IsIso fromTildeΓ ⟹ tilde), or
  (b) A redesigned proof that feeds `lem:isLocalizedModule_of_span_cover` with inputs that match
      what `lem:section_isLocalizedModule_of_presentation` actually delivers.

  **The chapter is `correct: partial` because `lem:qcoh_section_isLocalizedModule` has a proof gap
  at the descent step. HARD GATE for keystone dispatch does NOT clear.**

  **Informational: 3 blueprint nodes missing `\lean{}` hints.**
  - `lem:cech_free_eval_prepend_homotopy` (line 2238): NOTE in chapter explains the contracting
    homotopy is obtained by transporting `cechEnginePrepend` across the degreewise iso, so no
    standalone Lean decl exists; intentional.
  - `lem:cech_free_eval_prepend_homotopy_spec` (line ~2302): same situation (companion spec block).
  - One additional block starting with `lem:isIso_f…` — appears to be a to-build block awaiting a
    `\lean{}` annotation; not on an active prover route this iter.
  These are informational only; add `\lean{}` pins when the corresponding Lean declarations are named.

## Severity summary

**must-fix-this-iter**:
1. `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_section_isLocalizedModule`: proof sketch is
   incomplete — the descent step "under the section comparison …" is unjustified; a sheaf-gluing /
   Čech-H⁰ sub-lemma establishing `Γ(D(g_j),F) ≅ Γ(X,F)_{g_j}` as R-modules is missing from both
   the proof text and the `\uses` block. Chapter is `correct: partial`. **HARD GATE for keystone
   dispatch does NOT clear.** Dispatch the blueprint-writer for `Cohomology_CechHigherDirectImage.tex`
   with a directive targeting exactly this descent step, following the STRATEGY.md resolution
   candidate (P3 `exact_of_isLocalized_span` / sectionCech H⁰ route with tile-structured F_{(g_j)}).

**informational**:
- 3 blueprint nodes in `Cohomology_CechHigherDirectImage.tex` missing `\lean{}` hints
  (`lem:cech_free_eval_prepend_homotopy`, its spec companion, and one `lem:isIso_f…` block). Two
  are intentional per in-chapter NOTE; add `\lean{}` pins for the third when the decl name is known.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `correct: partial` — the keystone proof
sketch hides an unjustified descent step that requires a sheaf-gluing/Čech-H⁰ sub-lemma not present
in the chapter; the HARD GATE does NOT clear for keystone dispatch this iter. The two edited blocks
(B3b, B4) pass cleanly. The other two chapters (`Cohomology_HigherDirectImage.tex`,
`Cohomology_AcyclicResolution.tex`) are complete and correct. All 3 phases in the strategy have
adequate blueprint coverage — no unstarted-phase proposals.
