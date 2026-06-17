# Recommendations — for the iter-229 plan agent

## 0. Headline: the C-bridge verbatim-mirror route is EMPIRICALLY DEAD at H2′; the USER escalation BINDS

iter-228 hit the pre-committed **hard-block condition**. The C-bridge `dual_isLocallyTrivial`,
chosen *because the blueprint billed it the lower-risk verbatim mirror*, is a **genuine block**,
not budget exhaustion (empirically confirmed via `lean_goal`):

- Steps 1–3 + H1 of the mirror typecheck; the residual is
  `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)`.
- It does **NOT** close via `restrictScalarsRingIsoDualEquiv` (the dual is the **slice** internal
  hom — a morphism-module over `Over U` — not the sectionwise `restrictScalars`-image the tensor
  was, so there is no sectionwise strong-monoidal analogue).
- Closing it needs the **Mathlib-absent open-immersion slice-site equivalence** (`Over V` in
  `Opens Y` ≅ `Over (f''V)` in `Opens X`, transporting morphism-modules naturally), **~150–300 LOC**
  `Over.map`/pseudofunctor coherence.

**DO NOT re-dispatch the verbatim-mirror route.** It is falsified past H1. (A `% NOTE:` recording
this was added to `lem:dual_isLocallyTrivial` this iter.)

**The route's remaining cost grew** (slice-site equivalence ~150–300 LOC **on top of** the A-engine
~120–190 LOC). The frozen ~3–4-piece estimate now understates the truth. d.2-freeness is intact, so
the deep-math risk stays retired — but build size, the binding cost, is now materially larger.

### The live planner fork for iter-229 (the binding decision is the USER's — escalated via TO_USER)
- **(a) Scope the slice-site equivalence as a fresh sub-build** — the only non-idle forward motion
  under the standing directives (the harness never-idle rule forbids stalling on a user reply).
  **Before committing ~150–300 LOC, dispatch a `mathlib-analogist` (api-alignment) consult**: does
  Mathlib already have an open-immersion / `Opens.map`-induced `Over`-category equivalence (or a
  `TopCat.Opens` comma/slice reindexing) that supplies this? This is the cheap de-risking move — it
  could shrink the build substantially or reveal it exists. (The route bottomed out on an
  *unanticipated* obstacle the ts226descent analogist did not surface, so a targeted re-consult on
  the *specific* new shape is warranted before a large build.)
- **(b) Hold the route pending the USER RR-pause fork** — lifting the standing ROUTE C PAUSE lets
  `Pic⁰` be built via the divisor/Abel–Jacobi route (Kleiman §5), discarding the entire substrate.
  This is a USER-only action. The cost asymmetry (divisor ≈ Kleiman §5 ~600–1000 LOC **plus** the
  paused RR chain, vs the RR-free substrate ~3400–5500 LOC) is unchanged and now *more* in the
  divisor route's favour given the substrate's growing cost.

The loop proceeds on (a) by default unless a USER hint redirects. Per the iter-228 hard-block
pre-commitment, surface the escalation prominently (done in TO_USER).

## 1. Blocked targets — plan agent should NOT re-assign these as-is
- **`dual_isLocallyTrivial` via the verbatim mirror** — falsified at H2′ (see §0). Re-assign ONLY
  after the slice-site equivalence is built (or the route is abandoned per the USER fork).
- **`dual_unit_iso`** (`internalHom 𝟙_ 𝟙_ ≅ 𝟙_`) — off the critical path AND blocked on unit
  plumbing (`(restr U 𝟙_).obj (op (Over.mk (𝟙 U)))` has no `OfNat 1`; the unit generator must go
  through `PresheafOfModules.unit`'s section API, cf. `unit_map_one`). Do not pursue while the
  C-bridge is upstream-blocked. ~80–150 LOC if ever revisited.
- **`exists_tensorObj_inverse`** (L2143, the 80→79 mover) — needs C + A-engine + assembly; do not
  pin/stub. The in-body comment is accurate.
- **`isLocallyInjective_whiskerLeft_of_W`** (L659, vestigial d.2) — FORBIDDEN; do not touch.

## 2. Blueprint pin gaps (lean-vs-blueprint-checker tensorobj228 — 0 must-fix, 4 major) — planner/writer task
Report: `.archon/task_results/lean-vs-blueprint-checker-tensorobj228.md`
- The 3 new axiom-clean decls have **no blueprint block or `\lean{}` pin** (major ×3):
  `PresheafOfModules.dualPrecompEquiv` (L1558), `PresheafOfModules.dualIsoOfIso` (L1603),
  `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` (L1698). The planner should add prose blocks +
  `\lean{}` hints (e.g. `def:dual_precomp_equiv`, `def:dual_iso_of_iso`, `def:scheme_dual_iso_of_iso`)
  so `sync_leanok` can track them. **Do NOT instruct the writer to add `\leanok`** (sync-managed).
- `lem:dual_isLocallyTrivial` `\lean{}` pin is a **placeholder** (target decl absent); the `% NOTE:`
  added this iter documents it accurately. Retain the pin as a forward pointer; the writer must
  correct the Steps/H2′ sketch (verbatim mirror → slice-site equivalence) before re-dispatch.

## 3. Lean hygiene (lean-auditor ts228 — 0 must-fix, 2 major, 4 minor) — fold into a polish pass
Report: `.archon/task_results/lean-auditor-ts228.md`
- **(major, NEW)** `tensorObj_assoc_iso` (L1835–1836) declares **unused** `hM hN hP :
  LineBundle.IsLocallyTrivial` hypotheses — the proof is valid for arbitrary modules, so the
  signature **overstates the precondition** and could mislead callers. The decl is unprotected, so
  the hypotheses can be dropped without breaking the blueprint pin. Low urgency (disclosed in the
  docstring) but worth weakening in the polish pass. Verify no downstream caller relies on the
  current arity first.
- **(major, pre-existing)** Deprecated `CategoryTheory.Sheaf.val` API — 15 sites (2 new at L1688/L1700,
  following the file pattern). Already tracked as a deferred polish pass; the debt grows with each
  new `.val` decl. Migrate to `ObjectProperty.obj` once the dual block resolves.
- **(minor)** `dualPrecompEquiv` docstring (L1555): "commutes with this pre-composition" → the
  action *reassociates through* it (not a commutativity identity). **(minor)** presheaf `dualIsoOfIso`
  (L1603) silently relies on `cat_disch` for `isoMk` naturality — add a one-line comment.
  **(minor)** accumulated iter-number narrative + the stale iter-222/223 heartbeat-bomb note at
  L1514–1518 (the bomb was a stale Mathlib-bump artifact per iter-224) — strip in the polish pass.
  **(minor)** L368 `ext` unused pattern (cosmetic).

## 4. Reusable proof pattern landed this iter (recorded in PROJECT_STATUS Knowledge Base)
- **Iso-functoriality of the presheaf dual is cheap and separate from the pushforward commutation.**
  `dualPrecompEquiv` + `dualIsoOfIso` (presheaf + sheaf), axiom-clean. `PresheafOfModules.isoMk`'s
  naturality is discharged by the **default `cat_disch`** (slice-restriction coherence is
  definitional). Gotchas: `Preadditive.comp_add _ _ _ _ φ ψ` (3 explicit object args); qualify
  `CategoryTheory.Functor.map_id`; `change` (not `rw`) to beta-reduce structure-field lambdas. The
  CONTRAST is the lesson: iso-functoriality is trivial; the hard obstruction is the open-immersion
  **pushforward** commutation specifically (the slice-site equivalence).

## 5. Process note for the planner
- This is the **12th consecutive iter with no project-sorry-elim since iter-217**. The progress-critic
  has been STUCK/OVER_BUDGET for several iters and the hard-block has now fired. The next dispatch on
  this route (option (a)) should be **gated on the mathlib-analogist consult result** (does the
  slice-site equivalence exist / how large is it really) — do NOT send a prover into a blind ~150–300
  LOC build without first checking Mathlib has no shortcut. If the consult shows the build is genuinely
  large and Mathlib-absent, that strengthens the case for the USER to take fork (b).
