# Lean Audit Report

## Slug
quot-iter046

## Iteration
046

## Scope
- files audited: 1 (QuotScheme.lean — directive-narrowed scope)
- files skipped (per directive): 0 — directive explicitly restricted to one file

---

## Per-file checklist

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none (in focus area); 3 pre-existing "fills Mathlib TODO" comments at lines 763/785/814 are reference notes, not project excuse-comments
- **suspect definitions**: none in focus area
- **dead-end proofs**: none
- **bad practices**: 1 minor — `_` placeholder in anonymous IdealSheafData constructor (line 2765) obscures which field is auto-inferred; pre-existing style warnings (deprecated `Sheaf.Hom.mk` at lines 936–945; bare `maxHeartbeats` without explanatory comment at lines 1100/1163/1233/1252/1281)
- **excuse-comments**: none
- **notes** (focus area, lines 2718–2769):

  **`annihilator_map_basicOpen` (lines 2728–2740)**
  - Axiom check: passes — only `propext`, `Classical.choice`, `Quot.sound` (Lean stdlib axioms). No project axioms.
  - Sorry/admit/nativeDecide: none.
  - Unused hypotheses: none. `[F.IsQuasicoherent]` consumed by `isLocalizedModule_basicOpen`; `[Module.Finite Γ(X, V.1) Γ(F, V.1)]` consumed by `Module.annihilator_isLocalizedModule_eq_map`; `haveI := V.2.isLocalization_basicOpen f` provides `IsLocalization (Submonoid.powers f) Γ(X, X.basicOpen f)` required by the same algebra engine; the `letI Module.compHom` + `haveI IsScalarTower.of_algebraMap_smul` pair provides the `Module Γ(X, V.1) Γ(F, X.basicOpen f)` and `IsScalarTower` instances required by `isLocalizedModule_basicOpen`.
  - `Module.compHom + IsScalarTower.of_algebraMap_smul` idiom: correct. The `letI`/`haveI` pair is the documented pattern for supplying the scalar tower through which `isLocalizedModule_basicOpen` threads its instance arguments. Both are consumed. No instance diamond risk: the `Module Γ(X, V.1)` structure is explicitly `letI`'d and does not conflict with the ambient `Module Γ(X, X.basicOpen f)` structure on the RHS.
  - No `set_option` (not needed here; the ring-map identification `(X.presheaf.map ...).hom ↔ algebraMap` is defeq at default transparency).
  - Docstring: accurate. Blueprint-ref tags match the proof content. "Project-local because `annihilator` is" is a factual remark, not a quality hedge.
  - Statement is non-trivial: the basic-open coherence `(Ann M).map φ = Ann(localized M)` is a genuine algebraic identity, not a tautology.

  **`annihilator_ideal` (lines 2742/2761–2769)**
  - Axiom check: passes — only `propext`, `Classical.choice`, `Quot.sound`. No project axioms.
  - Sorry/admit/nativeDecide: none.
  - Unused hypotheses: none. `[F.IsQuasicoherent]` consumed by `annihilator_map_basicOpen` (called in the second bullet). `hfin` consumed via `haveI := hfin V` inside the `?_` discharge. `U` consumed in the first bullet's `congr(...)`.
  - `set_option backward.isDefEq.respectTransparency false` at line 2742: appropriate. The proof involves `IdealSheafData.ofIdeals_ideal` whose unfolding requires bumping transparency for `isDefEq` on implicit arguments. This is consistent with six other occurrences in the same file (lines 1102, 1165, 1235, 1254, 1283, 2617) all attached to proofs involving the same `ofIdeals` infrastructure.
  - Proof structure: `let I : X.IdealSheafData := ⟨fun V => ..., ?_, _, rfl⟩` uses an anonymous constructor with a deferred goal `?_`. First bullet closes the main goal via `congr($(IdealSheafData.ofIdeals_ideal I).ideal U)`; second bullet discharges the `map_ideal_basicOpen` field via `annihilator_map_basicOpen`. Both bullets are necessary and non-vacuous.
  - Minor: the `_` in position 3 of the constructor `⟨fun V => ..., ?_, _, rfl⟩` is auto-inferred by unification; it is non-obvious which `IdealSheafData` field this fills. Not wrong (the proof compiles and is axiom-clean), but a named argument would improve readability.
  - Docstring: accurate. The explanation of why `hfin` is needed (global finiteness → coherent family → `ofIdeals_ideal` applies) is correct and matches the proof.

  **Pre-existing tracked items (directive: note only if relevant)**
  - Lines 126, 165, 201, 228: `sorry` bodies on `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. Docstrings explicitly label them "iter-176 file-skeleton, body is a typed `sorry`". These are protected stubs tracked by the project; not new this iter, not escalated here.
  - Lines 936–945: deprecated `CategoryTheory.Sheaf.Hom.mk` (pre-existing). Not in focus area.
  - Lines 1100/1163/1233/1252/1281: `maxHeartbeats` bumps without explanatory comment — linter warning, pre-existing, not in focus area.

---

## Must-fix-this-iter

None.

Both new declarations (`annihilator_map_basicOpen`, `annihilator_ideal`) are axiom-clean, have no `sorry`/`admit`/`nativeDecide`, carry no excuse-comments, use all hypotheses, and have accurate docstrings.

---

## Major

None in focus area.

Pre-existing (not new this iter):
- `QuotScheme.lean:936–945` — deprecated `CategoryTheory.Sheaf.Hom.mk` usage (four occurrences). Should migrate to `ObjectProperty.homMk` per the deprecation note.
- `QuotScheme.lean:1100/1163/1233/1252/1281` — `maxHeartbeats` bumps with no explanatory comment. Linter asks for a comment stating the reason. Five occurrences.

---

## Minor

- `QuotScheme.lean:2765` — `_` placeholder in the third field of the `IdealSheafData` anonymous constructor. The auto-inferred field is not identified in the source; a named argument (`(someField := _)`) or a brief inline comment would make the structure field assignment self-documenting.

---

## Excuse-comments (always called out separately)

None flagged. No occurrence of `-- TODO: replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`, or `-- will fix later` in the two audited declarations or their docstrings. The "iter-177+" notes in the protected stubs are roadmap annotations, not quality admissions about code already in place.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0 (in focus area); 2 pre-existing outside focus area (deprecated API, bare heartbeat bumps)
- **minor**: 1 (anonymous constructor `_` in `annihilator_ideal`)
- **excuse-comments**: 0

Overall verdict: Both `annihilator_map_basicOpen` and `annihilator_ideal` are axiom-clean, properly justified, and free of sorry, excuse-comments, and unused hypotheses — the iter-046 additions land without audit blockers.
