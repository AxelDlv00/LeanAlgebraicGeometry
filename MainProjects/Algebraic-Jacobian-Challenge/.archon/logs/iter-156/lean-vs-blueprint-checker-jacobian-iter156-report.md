# Lean ↔ Blueprint Check Report

## Slug
jacobian-iter156

## Iteration
156

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Independent verifications performed
- **Import topology** (directive 2a): `RigidityKbar.lean:6` → `import AlgebraicJacobian.Rigidity`; `Rigidity.lean:6` → `import AlgebraicJacobian.Jacobian`. Confirmed cycle `Jacobian → RigidityKbar → Rigidity → Jacobian` if `Jacobian.lean` were to import `rigidity_over_kbar`. The Lean comment's gate (1) is **correct**.
- **`rigidity_over_kbar` signature** (RigidityKbar.lean:75–88): carries `[IsAlgClosed kbar] [CharZero kbar]`, hypothesis `genus C = 0`, concludes `f = (toUnit C ≫ η[A])`. The conclusion is **verbatim** the `key` goal of `genusZeroWitness`. The Lean comment's gates (2)+(3) are **correct**.
- **Base-change functor existence** (directive 2b): grep across `AlgebraicJacobian/` finds only `Module.finrank_baseChange` (an algebraic-module lemma in `Cotangent/GrpObj.lean`). There is **no** scheme-level base-change functor `Over (Spec k) → Over (Spec k̄)` in the project. The Lean comment's gate (3) is **correct**.

## Per-declaration

### `\lean{AlgebraicGeometry.genusZeroWitness}` (chapter: `def:genusZeroWitness`)
- **Lean target exists**: yes (`Jacobian.lean:209`).
- **Signature matches**: yes. `(h : genus C = 0) : JacobianWitness C` with `J := 𝟙_ (Over (Spec (.of k)))`. Matches the blueprint's "underlying scheme is `Spec k` (the terminal object), trivial group structure, smooth of relative dimension 0, proper, geometrically irreducible, `isAlbaneseFor` over every `P`."
- **Proof follows sketch**: partial. The 6 structural fields (`grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, plus pointed condition) mirror the blueprint's "Group-object/properness/smoothness/geometric-irreducibility" + "Smoothness of relative dimension `genus C`" + "pointed condition" paragraphs faithfully. The residual `key : f = toUnit C ≫ η[A]` sorry is **exactly** the `thm:rigidity_over_kbar` content (C.2 / C.2.g) — **not laundered, not broadened**. The uniqueness clause uses sound epi-cancellation of `toUnit C` (`Over.toUnit_left` + `Flat.epi_of_flat_of_surjective` + `Over.epi_of_epi_left` + `cancel_epi`), which **diverges from** the blueprint prose's (mathematically loose) "universal property of the terminal object" justification — already flagged by the in-chapter iter-155 `% NOTE:` (lines 618–629), fix still pending.
- **notes**: The single `sorry` is at `Jacobian.lean:265`, scoped precisely to `key`. The accompanying comment (lines 234–263) accurately documents three blockers, all independently verified above.

### `\lean{AlgebraicGeometry.positiveGenusWitness}` (chapter: `def:positiveGenusWitness`)
- **Lean target exists**: yes (`Jacobian.lean:299`).
- **Signature matches**: yes. `(hg : 0 < genus C) : JacobianWitness C`. Matches blueprint "genus ≥ 1, underlying scheme the Albanese variety, Route A."
- **Proof follows sketch**: N/A — body is bare `:= sorry` (line 303). Blueprint correctly states "Lean body … is currently `sorry`; closure contingent on Route A." Honest; gated, not laundered.
- **notes**: Acceptable Phase-C scaffold; off-critical-path per chapter.

### Supporting `\lean{...}` blocks (spot-checked, all faithful)
- `def:IsAlbanese` → `IsAlbanese` (Jacobian.lean:71): four AV conditions as typeclass binders, body the existential — matches `rem:IsAlbanese_typeclasses`. ✓
- `def:IsAlbanese_ofCurve` / `lem:IsAlbanese_comp_ofCurve` / `lem:IsAlbanese_exists_unique_ofCurve_comp` → the `Classical.choose`/`choose_spec` trio (lines 81–98). ✓
- `thm:IsAlbanese_unique` → `IsAlbanese.unique` (line 102): standard mutual-factorisation argument, matches prose + `rem:IsAlbanese_unique_iso`. ✓
- `def:JacobianWitness` → `JacobianWitness` (line 157): 7 fields exactly as enumerated. ✓
- `thm:nonempty_jacobianWitness` → `nonempty_jacobianWitness` (line 329): `by_cases h : genus C = 0` delegating to the two arms. Matches iter-135 restructure prose. ✓
- `def:Jacobian`, `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred` → `Jacobian` + four projection instances (lines 355–377). ✓

## Red flags

### Placeholder / suspect bodies
- None that are illegitimate. The two `sorry`s (`genusZeroWitness.key` at line 265; `positiveGenusWitness` at line 303) are both blueprint-acknowledged named gaps (`thm:rigidity_over_kbar` and Route A respectively), not placeholders masquerading as substantive proofs.

### Excuse-comments
- None. The long comment block at lines 234–263 is a precise, verified obstruction record, not a "wrong but works for now" excuse.

### Axioms / Classical.choice on non-trivial claims
- `IsAlbanese.ofCurve` and `jacobianWitness` use `Classical.choose`/`Classical.choice` legitimately to extract from existentials — authorized by the blueprint's extraction-API prose (`def:IsAlbanese_ofCurve`) and the `Classical.choice (nonempty_jacobianWitness C)` design. Not flagged.

## Unreferenced declarations (informational)
- `geometricallyIrreducible_id_Spec` (line 134): helper for the genus-0 `geomIrred` field. The blueprint **does** reference it by name+line in `def:genusZeroWitness`'s proof prose (line 608). Adequate.
- `jacobianWitness` (line 339): `Classical.choice` extractor; no `\lean{}` block but described in `thm:Jacobian_grpObj` proof prose. Acceptable helper.

## Blueprint adequacy for this file

- **Coverage**: 11/11 substantive declarations have a corresponding `\lean{...}` block (or are blueprint-named helpers). No orphan substantive declarations.
- **Proof-sketch depth**: adequate for the *structural skeleton* and the *math*, but **understated on Lean-architecture cost** for the residual `key` wiring — see the two majors below.
- **Hint precision**: precise. Every `\lean{...}` names the correct declaration with matching signature.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Disclose the import-cycle obstruction (major #1).
  2. Re-cost the C.2.f descent step (major #2).
  3. Land the two pending iter-155 `% NOTE:` rewrites (uniqueness prose; complete the `[CharZero]` disclosure in Layer I + intro).

## Adjudications requested by the directive

### Major #1 — Blueprint understates the import-cycle obstruction (directive 2a)
**Finding: confirmed.** `def:genusZeroWitness` (proof, line 616), C.2.f, C.2.g, infrastructure-(γ) (line 434), and Layer I (line 681) all describe `genusZeroWitness` as **directly consuming** `rigidity_over_kbar` ("By `thm:rigidity_over_kbar` … `f_{k̄}` equals the constant morphism"), and the statement block carries `\uses{thm:rigidity_over_kbar}`. The chapter **nowhere mentions** that `rigidity_over_kbar` lives downstream of `Jacobian.lean` in the import graph (`RigidityKbar → Rigidity → Jacobian`), making that consumption **impossible from within `Jacobian.lean`** without first relocating the rigidity stack upstream (or restating genus-0 rigidity in an importable location). This is a plan-level refactor the chapter silently assumes away. The Lean comment (gate 1) is more honest than the blueprint here.
**Severity: major.** The math is sound and the currently-landed Lean is correct; the chapter understates a real structural obstruction that blocks the *next* step (wiring `key`). Add a sentence to `def:genusZeroWitness` and C.2.g noting the relocation/restatement prerequisite.

### Major #2 — Blueprint understates the descent's true Lean cost (directive 2b)
**Finding: confirmed.** The chapter repeatedly calls C.2.f a "short (∼2-line) consequence of `Flat.epi_of_flat_of_surjective` + base-change-square commutativity" (C.2.f line 415, C.2.g line 417, infrastructure-(γ) line 434, Layer I line 681). Independently verified: the project has **no** base-change functor `Over (Spec k) → Over (Spec k̄)` (only the unrelated `Module.finrank_baseChange`). The "∼2 lines" claim is accurate **only for the final epi-cancellation**; it omits the prerequisite multi-iter sub-build the descent actually needs: (a) the base-change functor itself, (b) transfer of all relevant instances (`SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIrreducible`, `GrpObj`) to the base-changed objects, (c) genus-stability under base change, (d) the base-change-square identities `q ∘ f_{k̄} = f ∘ p`. The `def:genusZeroWitness` proof prose (line 616) presents (a)–(d) as if free/given ("Base-change the data … the curve `C_{k̄}` is again … `A_{k̄}` is again …"), then bills the whole thing at 2 lines. The Lean comment (gate 3) is correct that this is a multi-iter sub-build.
**Severity: major.** The chapter materially under-costs the genus-0 closure path. Re-cost C.2.f to separate the (cheap) epi-cancellation from the (expensive, currently-missing) base-change-functor infrastructure.

### Char-`p` hypothesis honesty (directive 3)
**Finding: mostly honest, with already-flagged residual understatements.** The chapter **does** disclose the char-`p` gap in the load-bearing places: C.2.g, infrastructure-(γ) (line 434), and the `def:genusZeroWitness` proof (line 616) all state `rigidity_over_kbar` "currently carrying `[IsAlgClosed k̄]` and `[CharZero k̄]`" and that route (c) would drop `[CharZero]`. The iter-155 `% NOTE:` (lines 630–636) explicitly corrects the bare-`[IsAlgClosed]` phrasing and confirms the Lean witness "correctly flags this gap." However, two passages still say only `[IsAlgClosed k̄]` without `[CharZero k̄]` — infrastructure-(γ)'s opening clause and Layer I (line 681: "carrying `[IsAlgClosed k̄]`"). The `% NOTE:` already lists exactly these sites for correction.
**Severity: minor** (pending the already-recorded NOTE fix). The Lean side (comment gate 2) is fully honest. No must-fix.

## Severity summary
- **must-fix-this-iter**: none. The Lean file is honest: both `sorry`s are blueprint-named gaps, no placeholder masquerades as substantive, no unauthorized axioms, signatures match prose.
- **major**:
  1. Blueprint silently assumes `genusZeroWitness` can consume `rigidity_over_kbar` despite the verified `RigidityKbar → Rigidity → Jacobian` import cycle — understates a real structural obstruction (directive 2a).
  2. Blueprint bills the C.2.f k̄→k descent as "∼2 lines" while the required base-change functor + 7-instance/genus-stability transfer does not exist in the project and is a multi-iter sub-build (directive 2b).
- **minor**:
  1. `def:genusZeroWitness` uniqueness prose still uses the loose "terminal object" justification rather than the sound epi-cancellation actually formalized (pending iter-155 `% NOTE:` item 1).
  2. Layer I + infrastructure-(γ) opening still say only `[IsAlgClosed k̄]`, omitting `[CharZero k̄]` (pending iter-155 `% NOTE:` item 2).

Overall verdict: The Lean `genusZeroWitness`/`positiveGenusWitness` faithfully realize their blueprint blocks and the residual `key` sorry is exactly the `thm:rigidity_over_kbar` gap (unlaundered); the chapter's only real defects are two *cost/obstruction understatements* (import cycle + descent) the Lean comments already capture more honestly — major but not must-fix, since the currently-landed Lean is correct.
