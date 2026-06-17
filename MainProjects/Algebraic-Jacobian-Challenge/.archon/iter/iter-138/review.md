# Iter-138 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED on piece (i.b) Step 2 retry** for
  `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
  at `AlgebraicJacobian/Cotangent/GrpObj.lean:500` (signature line)
  and shipped **PARTIAL with substantive body cut** — per the
  iter-138 progress-critic watch-flag (ii) constraint (helper-only
  without substantive body cut forbidden), the lane delivered
  end-to-end Route (b) skeleton landing with the additive (`d_add`) and
  Leibniz (`d_mul`) laws of the pointwise `KaehlerDifferential.D`
  derivation closed honestly. `meta.json` (presumed):
  `planValidate.status: ok`, `prover.status: done`, lane duration
  ~22 min (attempts_raw.jsonl timestamps 04:19–04:39Z; 69 events
  including 3 Edits + 4 diagnostic checks + 10 lemma searches + 11
  `lean_run_code` probes + 1 recovered `unexpected token '/--'`
  syntax error from the first body edit).
- **2 new declarations added + 1 main-decl body refactored**:
  - **`basechange_along_proj_two_inv_derivation`** (`Cotangent/GrpObj.lean:547`,
    `noncomputable def`, ~38 LOC declaration + 11 LOC docstring).
    Builds a `PresheafOfModules.Derivation'` on the transparent
    `(pushforward ψ).obj LHS` via `Derivation'.mk + ModuleCat.Derivation.mk`
    with the pointwise rule `b ↦ KaehlerDifferential.D _ ((ψ.app X).hom b)`.
    The `d_add` and `d_mul` laws closed via `RingHom.map_add/mul` +
    `ModuleCat.Derivation.d_add/mul`. **Two internal `sorry`s** at
    L581 (`d_app` zero-on-φ_G-image well-definedness) and L585 (`d_map`
    cross-open naturality).
  - **`basechange_along_proj_two_inv`** (`Cotangent/GrpObj.lean:596`,
    `noncomputable def`, ~15 LOC, **sorry-free**). Builds the inverse
    map `(pullback ψ).obj M_G ⟶ LHS` via
    `(DifferentialsConstruction.isUniversal' φ_G).desc` on the
    derivation above, then `(pullbackPushforwardAdjunction ψ).homEquiv
    ... |>.symm`.
  - **Refactored body of `relativeDifferentialsPresheaf_basechange_along_proj_two`**
    (`Cotangent/GrpObj.lean:612`, ~14 LOC = `letI : IsIso ... := sorry`
    at L624 + `(asIso _).symm` final term).
- **Sorry count delta**: 5 → **6** (+1 structural decomposition trade-
  off). The single iter-135 honest-scaffold body sorry on
  `_basechange_along_proj_two` was REPLACED by 3 narrowly-scoped
  concrete sub-sorries (d_app + d_map inside the helper, IsIso inside
  the main); the helper is a new declaration carrying the 2 inner
  sub-sorries, so `lake build` counts 6 declarations using sorry vs 5
  before. Per-file at iter-138 close (verified by `grep -E '(:= sorry
  |^\s*sorry\b|by sorry)'` + `lake env lean
  AlgebraicJacobian/Cotangent/GrpObj.lean`):
  - `Cotangent/GrpObj.lean:547` —
    `basechange_along_proj_two_inv_derivation` (NEW helper; 2 internal
    sub-sorries at L581 + L585).
  - `Cotangent/GrpObj.lean:612` —
    `relativeDifferentialsPresheaf_basechange_along_proj_two` (1 internal
    sorry at L624).
  - `Cotangent/GrpObj.lean:741` — `mulRight_globalises_cotangent` (Main;
    iter-135 carry-over, unchanged).
  - `Jacobian.lean:197` — `genusZeroWitness` (M2.b scaffold, unchanged).
  - `Jacobian.lean:223` — `positiveGenusWitness` (M3 scaffold, unchanged).
  - `RigidityKbar.lean:87` — `rigidity_over_kbar` (M2.a scaffold,
    unchanged).
- **2 mandatory review-phase audits dispatched + returned, divergent
  verdicts**:
  - `lean-auditor-review138` (345s/$2.34/29 turns, 14 files audited):
    **4 must-fix + 9 major + 3 minor + 3 critical excuse-comments**.
    Headline: "iter-138 landed a substantive structural skeleton for
    Route (b) of Piece (i.b), but the iso
    `_basechange_along_proj_two` and the main lemma
    `mulRight_globalises_cotangent` remain fully sorry-supported; the
    docstring framing slightly overstates progress and several long-
    standing forward-references have outlived their declared iter
    windows." All 4 must-fix items are the iter-138 sorries (L581 +
    L585 + L624 + L752); 3 critical excuse-comments are the "Iter-139+
    target" deferral-framing comments attached to the 3 new sub-sorry
    sites; 1 of the 9 majors is the docstring **framing overstatement**
    at L483–487 ("1 hollow scaffold sorry → 3 narrowly-scoped concrete
    sorries" reads as net progress when the iso is still fully
    sorry-supported); 5 of the 9 majors are carry-over file-header
    line-anchor drift; 3 of the 9 majors are long-deferred status text
    past its iter window (`rigidity_over_kbar` ~12 iters,
    `genusZeroWitness` ~iter "138+" landing at iter 138 with no
    closure, `HasAffineCechAcyclicCover` ~84 iters stale). See
    `task_results/lean-auditor-review138.md`.
  - `lean-vs-blueprint-checker-cotangent-grpobj-review138`
    (609s/$1.69/19 turns; single file ↔ single chapter):
    **PASS — 0 must-fix + 0 major + 3 minor**. All 8 `\lean{...}`-tagged
    declarations cross-check; iter-138 Route (b) helpers are direct
    realisations of the chapter's iter-137 NOTE prose; honest
    docstring framing per the checker's rubric. Minors: (1) 2 new
    iter-138 helpers lack dedicated `\lean{...}` blocks in
    `RigidityKbar.tex` (recommend iter-139+ blueprint-writer pin);
    (2) **possible `sync_leanok` mis-mark to flag** —
    `RigidityKbar.tex:491` carries `\leanok` on the proof block of
    `lem:GrpObj_omega_basechange_proj` while the Lean has `letI ...
    := sorry` at L624; review-agent does NOT manage `\leanok` per
    prompt, so this is flagging only for next-iter plan agent + a
    possible `sync_leanok` follow-up diagnostic; (3) carry-over
    file-header line-anchor drift. See
    `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review138.md`.
- **Compile-verified**: yes. `lean_diagnostic_messages` on
  `Cotangent/GrpObj.lean` returns 0 errors + 3 expected `declaration
  uses sorry` warnings at L547 + L612 + L741. `lake build` green
  (2888/2888 jobs succeed per the iter-138 prover's bash transcript;
  6 `declaration uses sorry` warnings across the whole build matching
  the per-file decomposition above).
- **No new axioms**. `archon-protected.yaml` unchanged (9 protected
  declarations). The iter-138 closure path uses only Mathlib API
  (`RingHom.map_*`, `ModuleCat.Derivation.d_*`,
  `PresheafOfModules.Derivation'.mk`,
  `PresheafOfModules.DifferentialsConstruction.isUniversal'`,
  `PresheafOfModules.pullbackPushforwardAdjunction`,
  `Scheme.Hom.toRingCatSheafHom`, `CategoryTheory.asIso`); kernel-
  axiom-only modulo the inner sorries.
- **`current_session/attempts_raw.jsonl` is FRESH** — 69 events,
  timestamped 2026-05-18T04:19–04:39Z, consistent with the iter-138
  prover stage. The `total_errors: 1` summary is the single recovered
  `unexpected token '/--'` syntax error during edit #1 (fixed by
  reformulating the inserted docstring as a `/-! ... -/` section
  header outside the tactic block in edit #2).
- **`TO_USER.md` left empty** — no impasse; iter-138 honored the
  PARTIAL-without-substantive-body-cut prohibition; the iter-138
  PARTIAL ceiling was satisfied by substantive body content (additive
  + Leibniz laws closed on the pointwise derivation, end-to-end
  Route (b) skeleton landed); iter-139 plan agent has clear direction
  per `session_138/recommendations.md`.

## Blueprint markers updated (manual this iter)

(none this iter)

Rationale:

- **No `\mathlibok`** candidates (iter-138 was a PARTIAL on a project-
  internal NEEDS_MATHLIB_GAP_FILL-track declaration; no Mathlib
  re-exports landed).
- **No `\lean{...}` renames** flagged (the two new helpers
  `basechange_along_proj_two_inv_derivation` and
  `basechange_along_proj_two_inv` are unreferenced from the blueprint
  but the checker classifies the gap as MINOR — recommend iter-139+
  blueprint-writer dispatch to pin them as
  `lem:GrpObj_omega_basechange_proj_inv_derivation` and
  `lem:GrpObj_omega_basechange_proj_inv` respectively; NOT a marker
  edit, that's writer territory).
- **No `\notready` strips** warranted — the iter-138 PARTIAL on
  `_basechange_along_proj_two` leaves the body still `sorry`-bodied,
  just structurally decomposed. The blueprint's `\notready` on the
  proof block of `lem:GrpObj_omega_basechange_proj` (RigidityKbar.tex
  L481) correctly remains in place. The proof-block `\leanok` on the
  iter-136-closed sibling `lem:GrpObj_omega_restrict_to_identity_section`
  is unchanged.
- **`sync_leanok`-domain finding (NOT touched by review agent)**: per
  the checker's MINOR 2, `RigidityKbar.tex:491` carries `\leanok` on
  the proof block of `lem:GrpObj_omega_basechange_proj` while the Lean
  has `letI ... := sorry` at L624. The review prompt is explicit: "Do
  not add or remove `\leanok` yourself." Flagged to recommendations
  for iter-139 plan agent diagnostic on the `sync_leanok` script's
  handling of `letI ... := sorry`-style tactic-block sorries.

## Notes section

- **Iter-138 progress-critic watch-flags absorbed**:
  - Watch-flag (i) — "single-blocker-doubling rule" (same
    `PresheafOfModules.pullback opacity` phrase in iter-138 PARTIAL
    flips iter-139 to CHURNING): **NOT TRIPPED**. The iter-138 prover
    diagnosed the opacity blocker (same as iter-137), then pivoted to
    Route (b) (the iter-137-recorded escape route) and shipped
    substantive body content. The single-blocker-doubling rule applies
    to the unchanged-blocker case; iter-138 changed approach.
  - Watch-flag (ii) — "helper-only without substantive body cut is
    forbidden": **SATISFIED**. Iter-138 ships substantive body cut —
    the additive + Leibniz laws closed on the pointwise derivation
    is substantive mathematical content (kernel-only modulo the inner
    sorries), end-to-end Route (b) skeleton landed; not helper-only.
- **Route 4 (piece (i.b)) verdict trend**: UNCLEAR-trending-CONVERGING
  (iter-137 progress-critic verdict) updated by iter-138 to **CONVERGING-
  with-caveat**: substantive structural decomposition is convergence-
  shaped (the 3 narrowly-scoped sub-sorries are independently
  dispatchable), but the auditor's "framing overstatement" finding +
  "fully sorry-supported" verdict on the iso is a legitimate caveat
  to the CONVERGING reading. Iter-139 progress-critic should re-
  evaluate.
- **Trigger (a')/(c) LOC arm NOT FIRED**. Iter-138 added ~92 LOC of
  body content + ~50 LOC docstring (total +142 LOC on
  `Cotangent/GrpObj.lean`, 612 → 754); cumulative iter-134→iter-138
  build on (i.b)-side is ~408 LOC of body content, comfortably inside
  the iter-137 renormalised 1000-LOC arm.
- **META-PATTERN TRIPWIRE held**: iter-138 prover lane targeted
  `_basechange_along_proj_two` (piece (i.b) Step 2 retry). Did NOT
  touch any piece (i.a) declaration or the iter-132-closed
  `cotangentSpaceAtIdentity` family.
- **3 critical excuse-comments flagged** by `lean-auditor-review138`
  at L577–581 (`d_app … Iter-139+ target. sorry`), L583–585 (`d_map
  naturality … Iter-139+ target. sorry`), L620–624 (`Iter-138 partial
  closure … The IsIso fact is the third concrete sub-piece … :=
  sorry`). The checker classifies the same comments as honest scoped
  proof-design notes; the two reviewers apply different rubrics on
  deferred-work framing. **Action**: recommendations.md CRIT-A
  instructs iter-139 prover-lane directive to drop "Iter-139+ target"
  deferral language and replace with neutral statements of unverified
  content.
- **1 major framing overstatement flagged** by `lean-auditor-review138`
  at L483–487 ("1 hollow scaffold sorry → 3 narrowly-scoped concrete
  sorries"). **Action**: recommendations.md CRIT-B instructs iter-139
  prover-lane directive to rewrite the iter-138 status block.
- **New Knowledge-Base candidate**: `simp` non-firing inside
  `Derivation.mk` lambdas (codified in `debug_feedback.md` this iter;
  Knowledge Base entry update below).
- **Negative iter-138 lesson**: the prover's choice of Route (b) over
  Route (a) (the directive's PRIMARY) was tactical (chart-unfolding-
  helper hits the same opacity blocker as iter-137; Route (b) admits
  typeable derivation construction without the helper). Iter-138
  shipped substantive body cut on Route (b); iter-139/140 needs to
  re-evaluate whether `IsIso` closure goes Route (a) (build the
  helper now as reusable infrastructure) or Route (b'2) (local-iso
  check). Recommend `mathlib-analogist` consult before iter-140
  dispatch (CRIT-D in recommendations.md).
- **No new axioms**; `archon-protected.yaml` unchanged.
