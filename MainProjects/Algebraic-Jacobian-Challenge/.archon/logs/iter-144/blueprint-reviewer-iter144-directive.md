# Blueprint Reviewer Directive

## Slug
iter144

## Strategy snapshot

The Jacobian project is mid-flight on **M2.body-pile piece (i.b) Step 2**
inside `AlgebraicJacobian/Cotangent/GrpObj.lean`. The blueprint chapter
for this Lean file is `blueprint/src/chapters/RigidityKbar.tex` (the
pointer chapter is `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`).

The piece (i.b) Step 2 closure path consists of three sub-sorries inside
`Cotangent/GrpObj.lean` :

- `basechange_along_proj_two_inv_derivation` (L573) carries a d_app
  sub-sorry at L663 (d_map at L664–700 closed iter-142).
- `basechange_along_proj_two_inv_app_isIso` (L745–751, NEW iter-143)
  is the extracted per-open IsIso obligation — body `sorry`, recipe is
  Route (b'2) items 2–4 at `RigidityKbar.tex:1167–1320`.
- `mulRight_globalises_cotangent` (L890–901) is the piece (i.b) Main;
  blocked on Step 2 closure (i.e. d_app + IsIso both close).

Iter-143 outcome on d_app: PARTIAL (no strict-count closure; the
iter-143 prover landed a 1-LOC `have hw` step 3.a categorical equality
but the c-level lift (3.b) + adjunction-transpose (3.c) + d_map
discharge (3.d) chase remains a `sorry` at L663). `lean-auditor-review143`
flagged the `have hw` as **dead-load** (introduced + never consumed
before the `sorry`); `lean-vs-blueprint-checker-cotangent-grpobj-review143`
flagged the iter-143 NEW theorem `basechange_along_proj_two_inv_app_isIso`
as **missing a first-class `\begin{theorem}` block** in the blueprint
(currently mentioned only in a `%`-commented NOTE at
`RigidityKbar.tex:1141`).

**Other off-critical-path open chapters:**
- `Jacobian.tex` — backs `Jacobian.lean` (`genusZeroWitness` L197 +
  `positiveGenusWitness` L223 + `nonempty_jacobianWitness` L249–254
  genus case-split). Off-critical-path scaffold; iter-143 PROGRESS.md
  watch criterion #9 flagged stale `\notready` at L389,424.
- `RigidityKbar.tex` itself backs `RigidityKbar.lean`
  (`rigidity_over_kbar` L75 + L87 `sorry`). M2.a body; iter-151+ target.
- All other chapters are closed end-to-end as of iter-120 close
  (cohomology + Mayer-Vietoris core/cover + differentials + Rigidity +
  Genus). The iter-143 reviewer audited 11 chapters with 10 at
  `complete: true / correct: true`.

**Iter-144 NEW user-hint reframings** (just applied to STRATEGY.md):
1. M3 is COMMITTED to **Route A — Picard scheme via FGA** (~6500 LOC
   midpoint). Route B (Symⁿ + Stein) is dropped from active
   consideration; historical alternative only.
2. **No user-escalation gates anywhere in STRATEGY.md**: the 5000-LOC
   hard-fallback, the "pivot strategy or escalate to user" off-track
   clause, and the iter-126 "TO_USER.md escalation" framing are all
   removed.
3. The iter-126 user-hint clarification: "do the work; no axioms;
   ~6500–9000 LOC is not that much for an AI" means the loop writes
   missing Mathlib material directly in-tree; the "off-loop PR lane"
   framing for M1.d `kaehler_quotient_localization_iso` is dropped;
   the "smallest PR-piece documentation" framing for
   `Mathlib.AlgebraicGeometry.RelativeSpec` is dropped. Both are
   ordinary in-tree project material now.

## Routes

Single committed route — over-k path with the bundled cotangent-vanishing
pile pieces (i)+(ii)+(iii). Iter-143 evidence: piece (i.a) closed
iter-132 + piece (i.b) Step 3 closed iter-136 + piece (i.b) Step 2
d_map closed iter-142. Open: piece (i.b) Step 2 d_app + IsIso + Main.

(M3 Route A is committed iter-144 but currently off-critical-path
pending M2 closure or the iter-150 RelativeSpec re-evaluation trigger.)

## References
- `references/challenge.lean`: Christian Merten's challenge spec
  (frozen protected signatures). Authoritative on the nine target
  declarations and their `[SmoothOfRelativeDimension n G.hom]`-style
  instance binders.
- `references/summary.md`: index file (recently captured).
- `analogies/d-app-d-map-recipe-shape.md`: load-bearing for piece (i.b)
  Step 2 d_app + d_map closure recipes (Decision 2 NEEDS_MATHLIB_GAP_FILL).
- `analogies/isiso-basechange-along-proj-two-inv.md`: Route (b'2) items
  1–4 for `basechange_along_proj_two_inv_app_isIso` body.
- `analogies/mulright-globalises-cotangent.md`: piece (i.b) Main
  closure path.

## Focus areas

- **`RigidityKbar.tex`** — verify the iter-143 NEW theorem
  `basechange_along_proj_two_inv_app_isIso` has (or doesn't have) a
  first-class `\begin{theorem}\label{...}\lean{...}` block. The
  lean-vs-blueprint checker iter-143 reported it as missing; iter-144
  needs the blueprint-writer dispatch to add one if confirmed missing.
- **`RigidityKbar.tex` Step 3 (3.a–3.d) sub-recipe** at L786 — does the
  recipe carry empirical lessons from iter-143's PARTIAL outcome
  (specifically, the type-coercion difficulty at step 3.b via
  `Pushforward.comp_eq` + `eqToHom`)? Iter-143's `task_results/Cotangent_GrpObj.lean.md`
  reports the residual is at the Lean-level type-coercion (not at
  the recipe level); the blueprint should disclose this.
- **`Jacobian.tex` stale `\notready` markers** at L389, L424.
- **`AlgebraicJacobian_Cotangent_GrpObj.tex` pointer chapter** iter-138
  status text — does it correctly reflect the iter-142 d_map closure
  + iter-143 IsIso extraction?
- **Multi-route check on M3**: per the iter-144 user-hint reframing,
  Route B is now historical alternative only. Verify the blueprint
  doesn't claim Route B requires active scaffold support; if it does,
  flag for blueprint-writer cleanup.

## Known issues
- Sync_leanok mis-mark count 3 at `RigidityKbar.tex:406, 524, 1152` —
  out of agent scope; deterministic sync_leanok phase handles. Do
  not re-report unless changed.
- The iter-143 `have hw` dead-load finding in
  `Cotangent/GrpObj.lean:637–638` is on the Lean side, not blueprint.
