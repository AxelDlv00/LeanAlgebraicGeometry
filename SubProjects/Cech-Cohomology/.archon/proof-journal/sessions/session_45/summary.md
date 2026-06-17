# Session 45 (iter-045) — review of the `tile_section_localization` assembly attempt

## Metadata
- **Sorry count:** 0 → 0 in `QcohTildeSections.lean` (project inline-sorry = 2, both frozen/superseded:
  dead `CechAcyclic.affine`, frozen P5b `CechHigherDirectImage`). No regression.
- **Build:** GREEN. `lake env lean … QcohTildeSections.lean` exit 0 (only pre-existing `Sheaf.val`
  deprecation warnings). All 5 new decls `#print axioms` = `{propext, Classical.choice, Quot.sound}`
  (prover `lean_verify`, independently consistent with the lean-auditor's fresh audit).
- **Lanes:** 1 planned, 1 ran (`mathlib-build`). **+5 axiom-clean decls, 0 new sorries.**
- **Target attempted:** `tile_section_localization` (the last keystone leaf) — **BLOCKED** on three
  compounding Lean-engineering walls; named target left absent (NOT papered with a sorry). 5 supporting
  helpers landed axiom-clean along the way.

## Headline — math complete, blocked on Lean engineering (W1–W3), not on mathematics
Every mathematical ingredient of `tile_section_localization` is now axiom-clean and present:
B4 presentation (`presentationModulesRestrictBasicOpen`), `IsLocalizedModule` over `R_g`
(`section_isLocalizedModule_of_presentation`), the image-opens identities (`tile_image_opens_identities`),
scalar-tower compat `R → R_g` at **both** opens (`tile_scalar_compat` at `V=⊤`, and the NEW
`tile_scalar_compat'` at `V=D(f̄)` built this iter), the base-ring descent
(`isLocalizedModule_powers_restrictScalars_of_algebraMap`), and the load-bearing map identity —
the tile restriction map over `V` IS `F`'s restriction over the image open `ι ''ᵁ V` **by `rfl`** on the
underlying type (the prover verified this with a scratch `example`, both as a section identity and as a
`LinearMap`). The full assembly nonetheless does not compile, blocked on:

- **W1 (pervasive):** any `Spec`-dependent instance introduced by `letI`/`haveI`/`have inst := …`
  (e.g. the native `Module R` on the tile carrier, the `IsScalarTower` `have`s, the `e0/e1`
  `(…mapIso…).toLinearEquiv`, `hdesc2`) hoists into a noncomputable auxiliary def and fails codegen:
  `failed to compile definition, consider marking it as 'noncomputable' because it depends on 'Spec'`.
  `noncomputable lemma` is rejected (`'theorem' subsumes 'noncomputable'`).
- **W2:** the `IsScalarTower R R_g (tile-carrier)` TYPE will not elaborate —
  `failed to synthesize SMul ↑R (tile-carrier)`; the tile carrier carries only `Module R_g`. Even with
  an explicitly-passed SMul, `of_algebraMap_smul`'s internal `[SMul R M]` stays unsynthesised, and
  matching `tile_scalar_compat`'s genuine `mod F`-instance `•` forces the SMul to BE the genuine one,
  which only stays transparent inline.
- **W3:** `whnf`/`isDefEq` timeout even at `maxHeartbeats 4000000` — the `hdesc2 := hdesc` carrier-`rfl`
  (`σ.restrictScalars R = F`-restriction over image opens) and the two `tile_scalar_compat`(`'`) defeqs
  through `modulesSpecToSheaf` + the restrict functor are very heavy.

Two concrete coding attempts (`letI`-based; and `@…of_algebraMap_smul` with explicit SMul) both
reproduced W1/W2 with the exact named errors. The needle-threading resolution (one giant inline
`exact @…` term + heartbeat/`show` mitigation) is large/delicate and was scoped to a follow-up
mathlib-analogist by the iter-045 objective itself.

## Per-target detail

### `tile_section_localization` — BLOCKED (see milestones for full attempt list)
- Math status COMPLETE; the blocker is purely Lean-engineering W1–W3 (above).
- DEAD ENDS confirmed (do not retry): (a) `rw [← (tile_image_opens_identities …).1/.2]` on the goal →
  "motive is not type correct" (opens sit in the dependent `homOfLE` proof); (b) `letI`/`haveI` for the
  tile `Module R` (W1); (c) `noncomputable lemma` (rejected); (d) raw `Scheme.Hom.appIso_inv_naturality`
  via `rw` (generic `Y.presheaf` form won't match — use the `appIso_inv_res` wrapper).

### Solved helpers (all axiom-clean)
- **`tile_scalar_compat'`** — general-open `V` scalar-tower compat; the `V=D(f̄)` instance is the
  planner's flagged NEW sub-need. Route-(A) template of the `V=⊤` `tile_scalar_compat`, generalized;
  needs `maxHeartbeats 1000000` for the carrier `convert`.
- **`tile_section_ring_identity'`** — general-open ring identity; `calc` post-composing the `V=⊤` case
  with the restriction, folded by `← Functor.map_comp` and pushed through the section isos via the two
  `appIso_inv_res` wrappers.
- **`modulesRestrictBasicOpen_smul_eq'`** — general-open tile-action `rfl` bridge.
- **`appIso_inv_res`, `appIso_inv_res_assoc`** (private) — `Scheme.Hom.appIso_inv_naturality` restated
  in `rw`-matchable form (explicit `homOfLE`/image opens), and its `Category.assoc`-folded variant.

## Key findings / patterns (added to PROJECT_STATUS.md Knowledge Base)
1. **Spec-dependent instances cannot be `letI`/`have`-introduced inside a lemma (W1).** Any `Module`/
   `LinearEquiv`/`IsScalarTower` instance whose definition mentions `Spec` hoists to a noncomputable
   aux def and fails codegen even in a Prop-valued lemma; `noncomputable lemma` is rejected. The only
   route is to pass every such instance inline (`@`-positions) in one term, never via `letI`/`have`.
2. **`Scheme.Hom.appIso_inv_naturality` is not directly `rw`-matchable** against `(Spec R).presheaf.map
   (homOfLE …).op` — its generic `Y.presheaf` RHS prints identically but fails the syntactic match.
   Wrap it with explicit `homOfLE`/image opens (`appIso_inv_res`) and provide a `Category.assoc`-folded
   variant for buried targets.
3. **A commented-out `lemma <name>` in the `.lean` file fools `sync_leanok`/`sorry_analyzer`** into
   marking the corresponding blueprint block `\leanok` (the keystone-leaf DAG-poisoning bug found this
   iter — see Blueprint markers below).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_section_localization`: **removed `\leanok` from
  both the statement block (was line ~4727) and the proof block (was line ~4749)**, added a `% NOTE`
  on each. Justification: the Lean declaration `AlgebraicGeometry.tile_section_localization` does NOT
  exist — only a commented-out sketch (`/- … lemma tile_section_localization … -/`) is present, blocked
  on W1–W3. Confirmed three ways: `grep` shows the `lemma` only inside a `/- -/` block; lean-vs-blueprint
  checker `qts` flagged it; the prover task result + the goal-state journal record its removal. The
  `\leanok` falsely marked the keystone leaf (and its whole downstream chain) as proved in the
  dependency graph. `sync_leanok` (iter-045, removed=0) did NOT clear it — the commented-out `lemma`
  text almost certainly fooled the analyzer. **This override is explicitly authorized** by the injected
  marker-sync attribution guidance ("authorized to manually override incorrect markers if you are
  certain"); I am certain. The `\lean{}` pin is retained (it names the intended target; sync will re-add
  `\leanok` when the real decl lands).
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_section_localization` (Step 4 prose, line ~4791):
  added `% NOTE` recording that the `V=D(f̄)` analogue the text says is "required" is now FORMALIZED as
  `tile_scalar_compat'`, with a planner pointer to author its block and refresh the paragraph.
- No `\leanok` *added* anywhere (sync owns additions; +14 this iter, sha ce13455).
- No `\mathlibok` (the 5 new decls are project theorems, not Mathlib re-exports).
- No `\lean{...}` rename (the 5 new decls need NEW blocks — coverage debt, listed in recommendations).

## Coverage debt (DAG `unmatched` = 6)
1 pre-existing dead (`CechAcyclic.affine`) + 5 new this iter, all needing blueprint blocks — listed in
`recommendations.md` for the planner.

## Subagent findings (reports linked, not duplicated)
- **lean-auditor `iter045`** (`task_results/lean-auditor-iter045.md`): all 5 new decls axiom-clean and
  kernel-sound (the `congr 1` / `convert … using 2` closures are genuine thin-cat subsingleton
  equalities, NOT the spurious-rfl trap); `maxHeartbeats 1000000` justified, not masking fragility;
  W1–W3 comment accurate. **MAJOR:** lines 1068–1108 of the `.lean` file are a STALE iter-043/044
  progress note claiming "full assembly now unblocked" — directly contradicting the iter-045 W1–W3
  blocked status above it; should be deleted (prover action — review does not edit `.lean`).
  **MINOR:** the `maxHeartbeats` comment precedes the `set_option … in` line, firing
  `linter.style.maxHeartbeats`.
- **lean-vs-blueprint-checker `qts`** (`task_results/lean-vs-blueprint-checker-qts.md`): the stale
  `\lean{}` pin + `\leanok` on the non-existent `tile_section_localization` (the must-fix above —
  ADDRESSED by the marker override); 5 new decls faithful but need their own blueprint blocks;
  Step-4 sketch under-specifies the W1–W3 walls; the `lem:tile_scalar_compat` `V=⊤`-only caveat is now
  stale (ADDRESSED by `% NOTE`).
