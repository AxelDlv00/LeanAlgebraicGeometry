# Blueprint Review Report

## Slug
iter144

## Iteration
144

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex`: the iter-143 NEW Lean target
  `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso`
  (Lean file `Cotangent/GrpObj.lean:745–750`, body `sorry`) has **no
  first-class `\begin{theorem}` block** in the blueprint. It is named
  only in a `%`-commented NOTE (`RigidityKbar.tex:1141` — inside the
  iter-143 refactor advisory inside the proof of
  `\thm{lem:GrpObj_omega_basechange_proj}`). The declaration is part of
  the active iter-144+ prover route (Route (b'2) items 2–4) and so its
  absence from the dependency graph is must-fix. The proper home is a
  new lemma block inside `RigidityKbar.tex` adjacent to
  `\thm{lem:GrpObj_omega_basechange_proj_inv}` (which currently sits at
  L1454–1522), labelled something like
  `lem:GrpObj_omega_basechange_proj_inv_app_isIso`, with `\lean{...}`
  hint pointing at the named declaration and `\uses{...}` linking to
  `\thm{lem:GrpObj_omega_basechange_proj_inv}`.

- `RigidityKbar.tex` Step 3 (3.a–3.d) d_app sub-recipe (L786–866):
  documents the iter-142 categorical-chase outline but does **not**
  carry the iter-143 empirical residual. Per the iter-143 prover-lane
  Lean residual at `Cotangent/GrpObj.lean:638–662`, the Step 3.a
  categorical equality `hw : (fst G G).left ≫ G.hom = (snd G G).left ≫
  G.hom` lands as a 1-LOC `rw [(fst G G).w, (snd G G).w]`, but the
  chase from 3.a → 3.b (c-component lift) → 3.c (adjunction-transpose
  through `pullbackPushforwardAdjunction`) → 3.d (`d_map` discharge) is
  blocked at the **type-coercion** layer: the `Pushforward.comp_eq`
  identification of `pushforward (fst).left.base ∘ pushforward
  G.hom.base` with `pushforward (G ⊗ G).hom.base` is up-to-`rfl`
  modulo `hw`, but threading it through the adjunction-transpose step
  requires explicit `eqToHom` rewrites that the iter-143 prover lane
  did not fit inside its envelope. This empirical lesson belongs in
  the Step 3.b prose alongside Rules 1–3 of the iter-142 empirical
  block.

### Proofs lacking detail

- `RigidityKbar.tex` / `\thm{lem:GrpObj_omega_free}` (L1572–1583): the
  proof is one paragraph, asserting "the pullback of a finitely
  generated free $k$-module along the structure morphism is a finitely
  generated free $\mathcal O_G$-module" with no named Mathlib lemma
  for the presheaf-of-modules-level pullback-of-free. Status is
  `\notready` so this is informational; when piece (i.c) becomes a
  prover target, the proof needs an explicit Mathlib name for the
  free-preservation under `PresheafOfModules.pullback` along the
  structure presheaf morphism (or a chart-localisation bridge plus
  free-preservation on each affine open).

- `RigidityKbar.tex` / `\thm{lem:GrpObj_omega_rank_eq_dim}`
  (L1585–1596): proof is one sentence, "The rank of the pulled-back
  bundle equals the $k$-dimension of its fibre." This is an unstated
  invocation of presheaf-of-modules-level rank-preservation under
  pullback. Off-critical-path / `\notready`; flagged informational.

### Lean difficulty quality

(No new findings — all `\lean{...}` hints in the open chapters are
well-formed signatures whose Lean targets exist, modulo the NEW IsIso
declaration that lacks a blueprint block but is sound on the Lean
side.)

### Multi-route coverage

- **Route over-k (committed, M2.a)**: PASS — the shared cotangent-
  vanishing pile pieces (i)+(ii)+(iii) over an arbitrary base field
  $k$ are documented end-to-end in `RigidityKbar.tex`. The iter-127
  over-k commitment is documented at L14 and reflected in the proof of
  `\thm{thm:nonempty_jacobianWitness}` at `Jacobian.tex:352`
  (sub-step C.2.f explicitly DROPPED). No Galois-descent scaffold
  remains in the blueprint.

- **M3 Route A (Picard scheme via FGA, committed iter-144)**:
  PARTIAL — `Jacobian.tex` § Route A (L255–284) decomposes the
  classical Picard-scheme route into A.1–A.4 with Mathlib status
  notes, and `\thm{def:positiveGenusWitness}` (L419–438) names the
  scaffold. However, per the iter-144 user-hint reframing (Route A
  midpoint ~6500 LOC committed; "no user-escalation gates"; the
  ~6500–9000 LOC budget is in-tree project material with no off-loop
  PR lane), the blueprint still frames Route A as "currently OFF-
  CRITICAL-PATH per STRATEGY.md § M3 (user-escalation-pending on the
  M3 prioritisation; the iter-126 user hint endorsed `do the work, no
  axioms; ~6500–9000 LOC may not be that much for an AI`)"
  (`Jacobian.tex:435`). The "user-escalation-pending" framing
  contradicts the iter-144 reframing — there is no user-escalation
  gate. **Blueprint-writer dispatch should reframe this proof
  paragraph to commit to Route A as the active in-tree M3 target with
  no escalation predicate.**

- **M3 Route B (Symⁿ + Stein, historical alternative only)**:
  COVERAGE-OVERSTATED — `Jacobian.tex` still presents Route B as an
  active alternative needing scaffold support: `\thm{def:positiveGenusWitness}`'s
  proof at L429–433 says "Both Mathlib-prerequisite routes that produce
  the seven fields of `\thm{def:JacobianWitness}` in positive genus
  require significant Mathlib infrastructure not currently available",
  and lists both Route A and Route B as routes to be prosecuted
  (L431–433). Per the iter-144 reframing Route B is dropped from
  active consideration; the blueprint should re-cast Route B as
  historical alternative only. The Route B prose body
  (`Jacobian.tex:286–311`) can be preserved as scholarly context but
  should be reframed as "the historical alternative route, not pursued
  in the project" rather than "an alternative route to be unlocked by
  Mathlib build-out β".

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Pointer-chapter status text for
    `basechange_along_proj_two_inv_derivation` (L51–58) is outdated.
    Current text: "The additive and Leibniz laws closed iter-138; the
    d_app (zero on φ_G-image) and d_map (cross-open naturality) laws
    remain sorry-bodied (iter-140 prover targets)." Iter-142 closed
    d_map; iter-143 left d_app PARTIAL (`hw` step 3.a landed,
    bespoke 3.b–3.d nat-trans chase remains sorry). The pointer
    should reflect iter-142 d_map closure and the iter-143 PARTIAL
    state on d_app.
  - Pointer-chapter status text for `basechange_along_proj_two_inv`
    (L59–69) is outdated. Current text: "IsIso of this morphism is
    the third concrete iter-140 sub-sorry (Route (b'2) per iter-139
    analogist verdict in `analogies/isiso-basechange-along-proj-two-inv.md`)."
    Iter-143 refactored the IsIso obligation into a NEW named
    declaration `basechange_along_proj_two_inv_app_isIso` (Lean
    file L745). The pointer should name this NEW declaration (with
    its current sorry status and iter-144+ prover-lane target
    designation) instead of describing IsIso as an in-consumer sub-
    sorry.
  - Pointer-chapter status text for `mulRight_globalises_cotangent`
    (L74–79) mentions only "iter-134+ prover-lane target". Iter-144
    is the actual target now per the iter-143 PROGRESS.md trace.
    Informational, but worth a refresh next blueprint-writer pass.
  - Pointer-chapter does not list the NEW iter-143 declaration
    `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso`
    in its `\itemize` of in-file Lean declarations. The pointer
    chapter's role is to enumerate the Lean file's contents; missing
    an iter-143 NEW declaration is a completeness gap. Same
    blueprint-writer pass should add it.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - The directive's "iter-143 PROGRESS.md watch criterion #9 stale
    `\notready` at L389, L424" is **already resolved**: a fresh
    `grep -n "notready" Jacobian.tex` returns no matches. L389 and
    L424 are the closing `\end{theorem}` lines of the
    `\thm{def:genusZeroWitness}` and `\thm{def:positiveGenusWitness}`
    blocks respectively; both blocks now ship without `\notready`.
    Watch criterion #9 can be cleared.
  - `\thm{def:positiveGenusWitness}` proof body (L429–438) still
    presents M3 as "OFF-CRITICAL-PATH per STRATEGY.md § M3 (user-
    escalation-pending on the M3 prioritisation; the iter-126 user
    hint endorsed `do the work, no axioms; ~6500–9000 LOC may not be
    that much for an AI`)". Per the iter-144 user-hint reframing
    captured in STRATEGY.md ("no user-escalation gates anywhere"),
    the "user-escalation-pending" framing is stale. Re-cast: Route A
    is the committed in-tree M3 target; the loop writes the
    ~6500-LOC build directly. **must-fix** (see Strategy-modifying
    findings).
  - `\thm{def:positiveGenusWitness}` proof body (L429–433) lists
    Route A and Route B as parallel "Mathlib-prerequisite routes"
    awaiting scaffold support. Per the iter-144 reframing Route B is
    historical alternative only. Re-cast the bullet list so that
    only Route A appears as the active project route, and Route B is
    described as a historical alternative not pursued. **must-fix**.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `-`

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **MISSING first-class block** for the iter-143 NEW Lean target
    `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso`.
    Currently mentioned only inside a `%`-commented NOTE at L1141.
    The Lean target carries a sorry body at `Cotangent/GrpObj.lean:745–750`
    and is the active iter-144+ prover round. **must-fix**: add a
    `\begin{lemma}` (or `\begin{theorem}`) block alongside
    `\thm{lem:GrpObj_omega_basechange_proj_inv}` (which appears at
    L1454), with `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}`,
    `\uses{lem:GrpObj_omega_basechange_proj_inv, lem:GrpObj_omega_basechange_proj}`,
    and a proof sketch citing Route (b'2) items 2–4 (the chart-
    level `Algebra.IsPushout`-from-affine-product helper, the
    `pullbackObjEquivTensor` chart-unfolding helper, and the
    per-open identification with `tensorKaehlerEquiv.symm`). All
    three sketches are already present, in `%`-commented form, at
    L1245–1320 — the blueprint-writer should extract them into a
    proper proof block.
  - Step 3 (3.a–3.d) d_app sub-recipe (L786–866) needs an
    iter-143 PARTIAL update. Step 3.a is now empirically validated
    to land as a single `rw [(fst G G).w, (snd G G).w]` step
    (1 LOC; per `Cotangent/GrpObj.lean:637–638`); Step 3.b is
    blocked at the `Pushforward.comp_eq` + `eqToHom` type-coercion
    layer (per the in-Lean status comment at
    `Cotangent/GrpObj.lean:650–662`). Add a Rule-4-style empirical
    block: "The categorical identification of `pushforward fst.left.base
    ∘ pushforward G.hom.base` with `pushforward (G ⊗ G).hom.base`
    modulo `hw` is up-to-`rfl` at the functor level but requires
    explicit `eqToHom` insertions when applied at a specific open;
    the bespoke nat-trans chase through
    `pullbackPushforwardAdjunction.homEquiv` must thread these
    `eqToHom` rewrites alongside `Adjunction.homEquiv_naturality_right_symm`."
    This empirical lesson should sit alongside iter-142 Rules 1–3
    so that iter-144+ prover lanes attacking d_app do not re-discover
    it.
  - The iter-143 NOTE block (L1132–1166) is `%`-commented and
    correctly documents the refactor of the IsIso obligation from a
    `letI := ... (fun _ => sorry)` inline shape into the NEW named
    theorem. Once the new first-class block (above) lands, this NOTE
    becomes the residual prose-only history; it can stay or be
    pruned at the blueprint-writer's discretion. Informational.
  - The `\notready` markers at L183 (`\thm{lem:GrpObj_cotangent_bridge}`),
    L1576 (`\thm{lem:GrpObj_omega_free}`), and L1589
    (`\thm{lem:GrpObj_omega_rank_eq_dim}`) are correct: each names a
    declaration that has no Lean target landed yet (the bridge is
    vestigial-on-live-path; the (i.c) free + rank lemmas are
    iter-145+ work).

## Cross-chapter notes

- `AlgebraicJacobian_Cotangent_GrpObj.tex` lists the Lean file's
  declarations in an `\itemize` and is supposed to be the index into
  `RigidityKbar.tex`'s "Piece (i)" prose. The pointer is now drifting
  iter-by-iter behind the Lean file: it last refreshed iter-138, while
  iter-142 (d_map closed), iter-143 (d_app PARTIAL + IsIso extraction)
  have landed. Same blueprint-writer pass that adds the missing
  RigidityKbar block (above) should refresh the pointer chapter
  entries for the three declarations involved
  (`basechange_along_proj_two_inv_derivation`,
  `basechange_along_proj_two_inv`, and the NEW
  `basechange_along_proj_two_inv_app_isIso`).

- `Jacobian.tex` C.2.g (L354) names `\thm{thm:rigidity_over_kbar}` and
  the shared pile pieces (i)+(ii)+(iii) consistently with
  `RigidityKbar.tex`'s decomposition (L65–79). No drift detected on
  the M2.a chain.

- `AbelJacobi.tex` § "Implementation route" (L85–89) cites the iter-127
  over-k commitment and references `\thm{thm:rigidity_over_kbar}`
  directly over $k$. Consistent with `Jacobian.tex` C.2.f DROPPED
  framing.

## Strategy-modifying findings

- `Jacobian.tex` / `\thm{def:positiveGenusWitness}` (proof body
  L429–438): the framing of M3 as "currently OFF-CRITICAL-PATH per
  STRATEGY.md § M3 (user-escalation-pending on the M3 prioritisation)"
  contradicts the iter-144 user-hint reframing now captured in
  STRATEGY.md ("no user-escalation gates anywhere"; Route A committed
  ~6500 LOC midpoint). STRATEGY.md has already been updated; the
  blueprint paragraph is the trailing artefact. **Resolution: a
  blueprint-writer pass on `Jacobian.tex` to re-cast Route A as the
  active in-tree M3 target with no escalation predicate, and Route B
  as a historical alternative not pursued.** This is a blueprint
  rewrite, not a strategy change — STRATEGY.md is already correct.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` missing first-class block for
    `basechange_along_proj_two_inv_app_isIso` (iter-143 NEW Lean
    target on the active iter-144+ prover route). Dispatch the
    blueprint-writing subagent with the proof-sketch material already
    sitting at `RigidityKbar.tex:1245–1320` so the new block can
    extract it into a `\begin{lemma}` block.
  - `Jacobian.tex` `\thm{def:positiveGenusWitness}` proof body
    Route A reframing per iter-144 user-hint (drop "user-escalation-
    pending"; commit ~6500 LOC midpoint in-tree).
  - `Jacobian.tex` Route B reframing as historical alternative only
    (already dropped from STRATEGY.md; blueprint paragraph still
    presents it as an active alternative).
  - `AlgebraicJacobian_Cotangent_GrpObj.tex` pointer-chapter status
    text refresh (iter-138 → iter-143) for the three (i.b) Step 2
    declarations.
  - `RigidityKbar.tex` Step 3 (3.a–3.d) sub-recipe at L786–866
    should be updated with an iter-143 Rule-4-style empirical
    block on the `Pushforward.comp_eq` + `eqToHom` type-coercion
    blocker at Step 3.b.

- **soon**:
  - Proof detail in `\thm{lem:GrpObj_omega_free}` (L1572–1583) and
    `\thm{lem:GrpObj_omega_rank_eq_dim}` (L1585–1596): when piece
    (i.c) becomes a prover target (iter-145+ per the projected
    sequencing), the proofs need Mathlib-name-level detail on
    presheaf-of-modules-level free + rank preservation under
    `PresheafOfModules.pullback` along the structure presheaf
    morphism.

- **informational**:
  - `AlgebraicJacobian_Cotangent_GrpObj.tex` L74–79: the
    `mulRight_globalises_cotangent` entry mentions "iter-134+
    prover-lane target". Iter-144 is the actual target; refresh
    next pass.
  - The directive's "Known issues" sync_leanok mis-mark count 3
    (RigidityKbar.tex:406, 524, 1152) is acknowledged — deterministic
    sync_leanok phase territory, not re-reported here.

**Overall verdict.** The blueprint's mathematical content is sound;
the M2.a chain (RigidityKbar.tex → Cotangent/GrpObj.lean → Jacobian.tex)
is consistent end-to-end. The must-fix items are all blueprint-writer
edits to capture iter-142/143 Lean-side progress and the iter-144
user-hint reframing; no strategy change is required. Five chapters
are clean; three carry must-fix annotations
(`AlgebraicJacobian_Cotangent_GrpObj.tex`, `Jacobian.tex`,
`RigidityKbar.tex`); the eight other chapters are off-critical-path
and clean.
