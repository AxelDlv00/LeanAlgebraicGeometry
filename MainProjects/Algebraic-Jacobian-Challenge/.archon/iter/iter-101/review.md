# Iter-101 (Archon canonical) / iter-103 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** with two targets:
  - Target 1 (Path B): close `alternating_zsmul_pi_smul_aux_sum_comp`
    body at L590.
  - Target 2 (Path A): close `cechCofaceMap_pi_smul` per-summand `hG`
    discharge — was L802, now L827.
- **Result**: **PARTIAL — 1 sorry closed**. Target 1 SOLVED via
  Path B's binder-level recipe. Target 2 FAILED across 5 Path A
  sub-routes; iter-103 committed two new forward-progress tactics
  (S4 ConcreteCategory→ModuleCat.Hom pivot at L823, S5 composition
  decomposition at L826) and the post-S5 frame is the deepest verified
  state at iter close.
- **Sorry trajectory**: BasicOpenCech 7 → 6 (target budget met, met via
  Path B not Path A as primary directed). Project total 15 → 14.
- **Compile-verified**: yes (`lean_diagnostic_messages` returns `[]` for
  severity=error end-to-end). **Ninth consecutive compile-verified
  prover iteration**.
- **No new axioms; no protected signatures touched.**
- **STREAK STATUS**: 4 consecutive substantive prover lanes on the
  `cechCofaceMap_pi_smul` hG slot (iter-099/100/101/103). Iter-102
  was a refactor pair. Streak-escalation criterion remains active;
  iter-104 MUST commit to Path C (refactor with named-T helper) or
  Path B with call-site restructuring (NO further raw-tactic passes).

## What the iter-101 plan got right

- **Path B body proof** lands in ~20 lines per the plan sketch's
  step structure (intro → Preadditive.sum_comp → simp_rw
  zsmul_comp → apply `alternating_sum_pi_smul_aux` with per-summand
  rfl-derivation + `map_zsmul` chain). The binder-level discrim
  tree analysis was vindicated: `G` and `E` as quantified binders
  allow `Preadditive.zsmul_comp` to fire on `(?n • G i) ≫ E`
  cleanly. Three iterations (099/100/101) had failed on the closure
  form; the open-binder form closes on first probe (modulo the
  `.map_zsmul` projection mishap).
- **S4 + S5 forward progress** at L823/L826 lands cleanly. S4 is a
  constant-level rfl rewrite (no Pi.lift in head) and S5 is a
  composition-decomposition simp. Both committed and verified.

## What the iter-101 plan got wrong

- **Path A `show`-pivot def-eq strategy** does NOT bypass the
  discrimination-tree blocker as the plan hypothesized. The plan
  predicted: "S5 (the (-1)^↑i extraction) requires either a
  heartbeat budget raise for a literal-body `show`, OR a structural
  refactor of the call site". Iter-103 attempt #3 (literal-body
  `show`) hit `whnf` heartbeat timeout at 1600000 — confirming
  iter-102's prediction that `show` also fails (heartbeat-prohibitive
  via def-eq across Pi.lift fun closure). Iter-103 attempt #4
  (`change` with `_`) failed via eqToHom-source metavar ambiguity.
  **Both planned-as-primary Path A routes are now dead.**
- **map_zsmul projection assumption**: the plan recipe assumed
  `(e₂ : _ →ₗ[k] _).map_zsmul (σ i) _` would work; in fact
  `LinearMap.map_zsmul` is not a projectable field, so the dot form
  fails. The free-standing `map_zsmul` (AddMonoidHomClass version)
  is the correct form. The prover repaired this on the fly
  (1 attempt cycle). **Lesson for iter-104 plan**: verify dot-form
  vs free-standing form for map-zsmul-style lemmas via
  `lean_loogle map_zsmul` before transcribing into the directive.

## What iter-103 discovered (deep)

### Path A is structurally dead in any in-place tactic frame

The discrim-tree blocker for `Pi.lift fun i_1 ↦ ...` is robust to:
- Forward `rw`/`simp only` on `(n • f) ≫ g` patterns (iter-099/100/101).
- Forward `rw`/`simp only` on `(n • f).hom x` patterns (iter-103 #1).
- Body-local rfl-helper for the equation, then `rw` with the local
  hypothesis (iter-099 E1 dead-end RE-CONFIRMED at iter-103 #2).
- Backward (`← LinearMap.comp_apply` + `← ModuleCat.hom_comp`)
  re-fusing (iter-103 #5: PARTIAL — works for non-smul layers, blocks
  at smul-prefix layer).
- `change` / `show` with full literal Pi.lift body (whnf heartbeat
  timeout; iter-103 #3 + iter-102 record).
- `change` / `show` with `_` placeholders (metavar ambiguity on
  eqToHom source; iter-103 #4).

The conclusion: **the blocker is at the smul-Pi.lift interface**,
not at the surrounding composition. Composition decomposition (S5)
brings the smul to the innermost layer, but the discrim tree still
refuses to match because the smul's RHS `Pi.lift fun i_1 ↦ ...`
itself has an anonymous-closure codomain that the discrimination
tree refuses to descend into. **No in-place tactic chain can fix
this** — only structural refactor (eliminate the closure by giving
each per-coord morphism a named-T binder).

### Path B's call-site application remains heartbeat-prohibitive

The iter-103 prover did NOT attempt Path B at the call site (L772).
The iter-102 record (12800000-heartbeat timeout) stands. Even with
the body closed, the call-site σ-Miller-unification through
Pi.lift's anonymous-closure codomain is the structural blocker.
**Manual unfolding of σ** at the call site (recommendations.md
Priority 2 step 2) may skirt this BUT may also fail — escalation
to Path C is the safer durable path.

### `map_zsmul` projection vs free-standing — one-call name-correction pattern

The dot-projection `(e₂ : _ →ₗ[k] _).map_zsmul` fails because
`LinearMap.map_zsmul` is not a projectable field. The free-standing
`map_zsmul` (from `Mathlib.Algebra.Group.Hom.Defs`, key
`AddMonoidHomClass.map_zsmul`) fires through `e₂`'s
`AddMonoidHomClass` instance. **Documented at L607 in
BasicOpenCech.lean.** This adds to the project-known
"plan-recipe transcription with one-call name-correction" meta-pattern
(iter-097, 099: lemma misnaming; iter-103: dot-vs-free-standing form).

## What's preserved byte-for-byte

- `alternating_sum_pi_smul_aux` body L478-L494 (iter-097).
- `alternating_sum_pi_smul_aux_sum_comp` L513-L537 (iter-098/099).
- `cechCofaceMap_pi_smul` prefix L640-L820 (iter-092 through
  iter-101 cumulative; iter-099 bridge at L700-L712; iter-100
  funext pivot at L726; iter-101 S1-S3 chain at L765-L779).
- `set_option maxHeartbeats 1600000 in` (L620; restored from iter-102
  transient 12800000 bump).

## What's NEW in iter-103

- `alternating_zsmul_pi_smul_aux_sum_comp` body at L590-L609 (was
  `sorry` — iter-102 refactor inserted shell; iter-103 closed it).
- `cechCofaceMap_pi_smul` S4-S5 forward progress at L823-L826
  (constant-level rfl pivot + composition decomposition).

## What iter-104 plan must do

See `recommendations.md` for the full directive. Headline:

1. **Schedule a refactor lane** (Priority 1, MANDATORY) with slug
   `cech-summand-via-named-T` introducing
   `cechCofaceMap_pi_smul_summand_via_named` with
   `T : ∀ j, Z₁ (h j) ⟶ Z₂ j` as a named binder family. Body sorry
   acceptable; apply at L827 site via `refine`.
2. **ALTERNATIVELY** schedule a Path B call-site prover lane
   (Priority 2) with manual σ-unfolding. Less durable; may hit
   whnf timeout.
3. **DO NOT** schedule any further raw-tactic prover lane on L827
   in its current frame. Plan must formally forbid this — five
   route classes are now confirmed dead.
4. If iter-104 also stalls (5th consecutive substantive lane),
   formally pause `cechCofaceMap_pi_smul` and move to
   `Differentials.lean` L636 Route A/B decision.

## File state at iter-103 close

- Sorries: 6 in `BasicOpenCech.lean` (L827, L919, L1243, L1271,
  L1461, L1490); 14 total across the project.
- `lean_diagnostic_messages` severity=error: `[]`.
- New axioms: none.
- Protected signatures: none touched.
- Inner-git commit log: prover stage commit `archon[101/prover/...]`
  + this review's session journal + iter sidecar.

## Honesty note

The iter-103 prover delivered exactly what was achievable under
the bounded directive: Path B body closure (the one durable closure
available given the iter-102 refactor's pre-staging) plus two
forward-progress tactics at the call site, plus a clean exhaustive
exploration of Path A's remaining sub-routes. This is the
correct outcome under the structural constraints — the call-site
closure was always going to require iter-104 structural escalation.
The streak narrative should NOT read as "another stall" but as
"the producer-consumer cycle's second half is ready for a fresh
structural refactor lane (analogous to iter-098 split-slot → iter-099
bridge application — here, iter-104 named-T refactor → iter-105
hT discharge)".

## Developer feedback channel

Skipped this iter — no concrete Archon-tooling observation.
