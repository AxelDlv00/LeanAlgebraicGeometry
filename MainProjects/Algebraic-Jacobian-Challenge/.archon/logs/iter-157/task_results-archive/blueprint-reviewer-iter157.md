# Blueprint Review Report

## Slug
iter157

## Iteration
157

## Top-level summaries

### Incomplete parts
- `Jacobian.tex` / `sec:av_rigidity_route_c`: the committed genus-0 route (c) chain
  (`thm:theorem_of_the_cube`, `lem:rigidity_theorem`, `cor:complete_product_to_AV_decomp`,
  `lem:rational_map_to_AV_extends`, `prop:unirational_to_AV_constant`,
  `prop:rigidity_genus0_curve_to_AV`) is **dangling**: its headline
  `prop:rigidity_genus0_curve_to_AV` is referenced by nothing except its own `\uses`.
  The declaration it is meant to prove — `thm:rigidity_over_kbar` (in `RigidityKbar.tex`) —
  has a proof decomposition (C.2.b–C.2.e) that still reduces entirely to "produce `df=0`"
  and never mentions route (c). The committed route is stated but not wired into the
  thing it discharges.
- `Jacobian.tex` / `thm:theorem_of_the_cube`: stated with **no proof** (Milne defers it;
  the `% SOURCE QUOTE PROOF` is literally "We defer the proof until later in this section").
  This is the deepest input of the whole route-(c) tower and is currently un-formalizable
  from the blueprint.
- `Jacobian.tex` / `lem:rational_map_to_AV_extends`: "proof" is a one-line pointer to
  Milne Thm 3.1 + Lemma 3.3, neither of which is stated as a blueprint block. Not
  formalizable as written.
- `RigidityKbar.tex`: the chapter that *hosts* the committed-route declaration
  `thm:rigidity_over_kbar` has **zero coverage of route (c)** — 37 `df=0`/Serre framing
  hits, no mention of theorem-of-the-cube / Milne / unirational / route (c). The committed
  strategy has no blueprint home in the chapter that owns the gated declaration.

### Proofs lacking detail
- `Jacobian.tex` / `thm:theorem_of_the_cube`, `lem:rational_map_to_AV_extends`: cite Milne's
  terse course notes ("combine Theorem 3.1 with the next lemma"). The project now has
  **Mumford, *Abelian Varieties*** bundled (`references/mumford-abelian-varieties.{md,pdf}`)
  — the canonical full-proof source. These two blocks (and ideally `lem:rigidity_theorem`)
  need substantially more proof detail sourced from Mumford before a prover can attempt
  them; Milne-citation level is not enough for the cube / rational-map-extends inputs.
- `Jacobian.tex` / `def:genusZeroWitness` proof, "Uniqueness" paragraph: still justifies
  uniqueness of `g` by "the universal property of the terminal object" — mathematically
  loose (morphisms *out of* a terminal object are not unique). The `% NOTE:` (1) flagging
  this and giving the sound epi-cancellation argument is present but the prose is unchanged.

### Lean difficulty quality
- `Jacobian.tex` / all six route-(c) blocks: **no `\lean{...}` hints at all.** The directive
  asks whether the intended Lean names/signatures are specified clearly enough to scaffold a
  NEW upstream file — they are not. There is no named target for the cube, the rigidity
  theorem, the product decomposition, rational-map-extension, or unirational-constancy. A
  prover/scaffolder has nothing to instantiate. (These are statement-level for now, so this
  is "soon" not "must-fix" on the Lean-quality axis — but it must be resolved before any
  route-(c) prover lane opens.)

### Multi-route coverage
- Route (c) — theorem-of-the-cube → rigidity-lemma (COMMITTED genus-0 path): **PARTIAL.**
  Stated at statement+citation level in `Jacobian.tex` `sec:av_rigidity_route_c`, but
  (i) not covered in `RigidityKbar.tex` where `thm:rigidity_over_kbar` lives, (ii) not wired
  into `thm:rigidity_over_kbar`'s proof decomposition, (iii) headline blocks (cube,
  rational-map-extends) too thin to formalize, (iv) no `\lean{}` targets.
- Route (a) — `df=0` / cotangent-triviality + Serre duality (fallback): **PASS** (as a
  fallback). Covered exhaustively in `RigidityKbar.tex` `sec:RigidityKbar_shared_pile` +
  chart-algebra envelope; iter-155 self-corrections (Serre duality is on the critical path,
  chart-algebra supplies only the converse) are correctly woven in.
- Route (b) — dual abelian variety via `Pic⁰(ℙ¹)=0` (fallback): **PARTIAL/informational.**
  Mentioned in both chapters as an alternative; no dedicated blocks. Acceptable for a
  fallback, but note `RigidityKbar.tex` lists (a) and (b) as the only two candidate closure
  routes and "commits to neither", directly contradicting `Jacobian.tex`'s commitment to (c).

### Citation discipline
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: `% SOURCE` reads "Mumford, Abelian
  Varieties, Ch. II §4 (verbatim text not yet retrieved — paywalled, no open copy in
  references/). No SOURCE QUOTE is supplied". **This is now stale**: Mumford's *Abelian
  Varieties* IS bundled (`references/mumford-abelian-varieties.{md,pdf}`). A verbatim
  `% SOURCE QUOTE:` can and should now be extracted. (The route-(c) blocks in `Jacobian.tex`
  already cite Milne verbatim with the four-element discipline intact — those are clean.)
- `Jacobian.tex` route-(c) blocks: `% SOURCE` parentheticals read
  "(read from references/abelian-varieties.pdf)" (the Milne PDF, which exists). Convention
  prefers the `.md` mirror; the `.pdf` with page numbers is acceptable and the file exists,
  so not a fail — informational only.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
(All declaration blocks `\leanok`; no `sorry`/`\notready`/gap markers.)

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:Scheme_AffineCoverMVSquare_corners` carries no `\lean{}`/`\leanok` (organizational
    statement); it is immediately superseded by the four `_X₁`..`_X₄` lemmas which are all
    `\leanok`. Harmless; could be dropped or marked. Informational only.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter; mathematical content lives in `RigidityKbar.tex`.)

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.
(All blocks close by projection from the Albanese witness; gated on the disclosed named gap
`thm:nonempty_jacobianWitness`, which is correctly characterized as the single foundational
hypothesis.)

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Route-(c) chain (`sec:av_rigidity_route_c`) is stated but **not wired** into
    `thm:rigidity_over_kbar`; `prop:rigidity_genus0_curve_to_AV` is consumed by nothing.
    Committed route is dangling.
  - `thm:theorem_of_the_cube` has no proof; `lem:rational_map_to_AV_extends` has only a
    citation-pointer "proof". Too thin to formalize — needs Mumford-sourced detail.
  - No `\lean{}` targets on any of the six route-(c) blocks (cube, rigidity thm, product
    decomp, rational-map-extends, unirational-constant, genus-0-curve-to-AV).
  - CARRY-OVER (1) **live**: `def:genusZeroWitness` "Uniqueness" prose still uses the
    mathematically-loose terminal-object justification; sound epi-cancellation argument is
    only in the `% NOTE:`, not the prose.
  - CARRY-OVER (3) **live**: the import-cycle obstruction
    (`Jacobian → Genus`, `Rigidity → Jacobian`, `RigidityKbar → Rigidity`) means
    `Jacobian.lean` cannot consume `rigidity_over_kbar` without a cycle — verified against
    the actual `import` lines. The proof prose still describes direct consumption; the
    `% NOTE:` (3) flags it but the obstruction is unresolved and needs a plan-level relocate
    of the rigidity stack upstream of `Jacobian`.
  - CARRY-OVER (4) **live**: descent sub-step C.2.f is still billed "~2 lines" in the body
    (C.2.f, C.2.g, infrastructure-(γ)) while the `% NOTE:` (4) correctly re-costs it as a
    multi-iter base-change sub-build (no `Over (Spec k) → Over (Spec k̄)` functor exists,
    instance transfer + genus-stability + base-change-square identities all needed).
  - Citation discipline of the route-(c) Milne blocks themselves is clean (four-element
    discipline intact, verbatim quotes in English matching Milne).

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **No coverage of the committed route (c).** The chapter hosts the gated declaration
    `thm:rigidity_over_kbar` but its proof decomposition (C.2.b–C.2.e) and shared-pile
    framing are entirely route-(a) (`df=0`/cotangent/Serre) + route-(b) (dual-AV), and it
    explicitly "commits to neither". `Jacobian.tex` committed to route (c). Stale framing
    relative to the decided strategy — this is the central must-fix.
  - `% archon:covers RigidityKbar.lean Cotangent/ChartAlgebra.lean` uses paths relative to
    `AlgebraicJacobian/`; blueprint-doctor resolves relative to repo root and flags them
    nonexistent. **Confirmed fix**: write full paths
    `% archon:covers AlgebraicJacobian/RigidityKbar.lean AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
    (both files verified to exist at those locations).
  - `thm:rigidity_over_kbar` `% SOURCE` claims Mumford is "paywalled, no open copy in
    references/" and supplies no `% SOURCE QUOTE` — now stale (Mumford is bundled).
  - The chapter is internally consistent and self-corrected at iter-155 (Serre duality is
    on the critical path; chart-algebra supplies only the converse). The lemma blocks
    (piece (i)/(ii)/KDM/constants) are sound; `[IsAlgClosed kbar] [CharZero kbar]` framing
    matches the verified Lean signature (`RigidityKbar.lean:75-76`). The gap is purely the
    missing committed-route coverage.

## Cross-chapter notes

- **Route mismatch (the central finding).** `Jacobian.tex` commits the genus-0 critical
  path to route (c) (theorem-of-the-cube → Milne Prop 3.10), demoting `df=0`/Serre to
  fallback (a) and dual-AV to fallback (b). `RigidityKbar.tex` — which owns the gated
  declaration `thm:rigidity_over_kbar` that route (c) is supposed to discharge — still
  frames the entire proof around `df=0` and lists only routes (a) and (b), "committing to
  neither". The two chapters disagree on the live route. Resolution: a blueprint-writer must
  bring route (c) into `RigidityKbar.tex` as the committed proof route for
  `thm:rigidity_over_kbar` (re-pointing the C.2.d keystone at `prop:rigidity_genus0_curve_to_AV`
  / the cube chain), demoting the `df=0`/Serre pile to fallback there too.
- **Route (c) home / `% archon:covers` design (directive Q3b).** The route-(c) blocks
  currently sit in `Jacobian.tex` but will need a NEW Lean file *upstream* of `Jacobian`
  (forced by the import-cycle obstruction — they cannot live in `Jacobian.lean`).
  Recommendation: give the AV-rigidity stack its **own chapter** (1:1 with the new upstream
  Lean file), NOT a consolidated `% archon:covers` on `Jacobian.tex`. Reason: a consolidated
  cover makes one verdict gate every listed file, so the not-yet-existent, heavy route-(c)
  stack would block the otherwise-clean `Jacobian.lean` projection declarations. A separate
  chapter isolates the route-(c) verdict and mirrors the import structure. The route-(c)
  blocks should migrate from `Jacobian.tex` to that new chapter when it is created.
- No broken `\uses{}` cross-references anywhere (the apparent `lem:S3_*` / `\uses{...}`
  hits are inside `%` comments, not live references; verified).

## Strategy-modifying findings (if any)

- `Jacobian.tex` / `def:genusZeroWitness` + `RigidityKbar.tex` / `thm:rigidity_over_kbar`:
  the **import-cycle obstruction** (carry-over NOTE 3) is a structural blocker that the
  blueprint cannot fix by prose alone. As long as the rigidity stack lives in
  `RigidityKbar.lean` (which imports `Rigidity → Jacobian`), `genusZeroWitness` in
  `Jacobian.lean` cannot consume `rigidity_over_kbar`. Closing the genus-0 arm via route (c)
  requires a **plan-level decision** to relocate the rigidity stack (and the new route-(c)
  AV file) UPSTREAM of `Jacobian.lean`. This should be reflected in STRATEGY.md / the file
  layout before any route-(c) prover lane opens. Flagging here because it gates the entire
  committed genus-0 path, not just one chapter's prose.

## Severity summary

- **must-fix-this-iter**:
  - `Jacobian.tex` is `complete: partial` / `correct: partial` → dispatch a blueprint-writer:
    wire route (c) into `thm:rigidity_over_kbar`; flesh out / Mumford-source the cube and
    rational-map-extends blocks (or mark them explicitly as deferred deep inputs); land the
    three live carry-over NOTE corrections (uniqueness epi-cancellation, import-cycle honesty,
    descent re-cost); add intended `\lean{}` names for the route-(c) targets.
  - `RigidityKbar.tex` is `complete: partial` → dispatch a blueprint-writer: add committed
    route-(c) coverage for `thm:rigidity_over_kbar`, demote `df=0`/Serre to fallback; fix the
    `% archon:covers` paths to repo-root-relative full paths; refresh the stale Mumford
    `% SOURCE` (now bundled) and add a verbatim `% SOURCE QUOTE`.
  - Route (c) under "Multi-route coverage" is PARTIAL (committed route, insufficient
    coverage in the owning chapter) → blueprint-writer dispatch as above.
  - Strategy-modifying finding (import-cycle relocation) is non-empty → STRATEGY.md / layout
    decision before route-(c) Lean work.
- **soon**:
  - No `\lean{}` targets on route-(c) blocks (not yet on an active prover lane, but must be
    resolved before scaffolding the new upstream file).
  - `RigidityKbar.tex` stale Mumford `% SOURCE` (block not on an active prover lane).
- **informational**:
  - `Cohomology_MayerVietoris.tex` `lem:..._corners` unmarked organizational lemma.
  - Route-(c) `% SOURCE` cites `abelian-varieties.pdf` rather than the `.md` mirror (file
    exists; convention preference only).

Overall verdict: The blueprint is healthy except for the genus-0 critical path — route (c)
is committed in `Jacobian.tex` but un-wired, statement-thin, `\lean{}`-less, and entirely
absent from `RigidityKbar.tex` (which still frames its gated declaration around the demoted
`df=0` route); both chapters are `partial` and need a coordinated writer pass plus a
plan-level import-cycle/layout decision before any route-(c) prover lane opens.
