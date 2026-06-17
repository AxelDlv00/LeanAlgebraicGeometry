# progress-critic directive — ts228

Assess convergence of the single active prover route below. Fresh-context read:
is this iter's proposed objective genuine convergence, or more helper accretion on
a route that has not eliminated a project sorry in many iters?

## Active route: A.1.c.SubT — ⊗-group-law substrate (file `Picard/TensorObjSubstrate.lean`)

The route builds a d.2-FREE descent re-route to close the project sorry
`exists_tensorObj_inverse` (the 80→79 mover). It needs three bridges to be assembled:
- **B-connector** `isIso_of_isIso_restrict` (locally-iso ⇒ global iso) — CLOSED iter-226.
- **C-bridge** `dual_isLocallyTrivial` (the dual of a line bundle is a line bundle), via
  the restrict-iso `(dual M).restrict f ≅ dual(M.restrict f)` — a verbatim mirror of the
  CLOSED `tensorObj_restrict_iso` (H1 reused verbatim; H2′ core
  `restrictScalarsRingIsoDualEquiv` BUILT axiom-clean iter-227). NOT YET assembled.
- **A-bridge** `homOfLocalCompat` (compatible local module morphisms glue to a global one)
  — a ~120–190 LOC SheafOfModules-morphism-descent engine. NOT landed; precisely localized:
  only its `localSection` naturality sub-piece carries real coherence risk.

### Signals — last 5 iters (sorry count / helpers added / status / blocker phrases)

- **iter-223**: project sorry 81. No close. (whnf-bomb investigation — later found stale.)
- **iter-224**: project 81→80 (closed a self-introduced `internalHomEval` stub). Helpers +1
  (`internalHomEval` naturality). Status: sub-step retired. Blocker phrase: none new.
- **iter-225**: project 80→80. Helpers +1 (`Scheme.Modules.dual`, axiom-clean). Status PARTIAL
  (dual object landed = sub-step success). Blocker: "descended eval sorry-transitive through d.2".
- **iter-226**: project 80→80. Helpers +1 (`isIso_of_isIso_restrict` B-connector, axiom-clean).
  Status PARTIAL. Blocker phrase: "B is off the critical path; two bridges remain".
- **iter-227**: project 80→80. Helpers +3 (`homMk`, `toPresheaf_map_homMk`,
  `restrictScalarsRingIsoDualEquiv`, all axiom-clean). Status PARTIAL. The A-bridge engine
  `homOfLocalCompat` did NOT land (cause: build SIZE ~120–190 LOC, NOT a re-emergent d.2 gap).
  C-probe returned DECISIVELY d.2-free. Blocker phrases: "no project-sorry-elim since iter-217",
  "bridge accretion", "build SIZE not d.2".

Recurring across the arc: **11 consecutive iters (since iter-217) with no downward move in the
project sorry counter**; each iter lands axiom-clean infrastructure but `exists_tensorObj_inverse`
(80→79) never closes. The deep math risk (d.2 stalk-⊗) is confirmed AVOIDED; remaining cost is
bounded category-theory engineering.

### STRATEGY estimate vs elapsed

- Phase row "A.1.c.SubT": current `Iters left` = **~4–8** (revised up iter-227).
- Phase entered its current state at **iter-219** → **9 iters elapsed** as of iter-228.

### Prior verdict (ts227)

STUCK + OVER_BUDGET (2× over the original ~3–5-iter estimate). Sanctioned iter-227 as the
route's "terminal grace window" with a tripwire: land the A-bridge axiom-clean OR escalate the
RR-pause fork to the USER. The A-bridge did NOT land → the tripwire FIRED. The RR-pause fork
(lift the standing ROUTE C PAUSE → build `Pic⁰` via the cheaper divisor/Abel–Jacobi route,
discarding this substrate) is GATED ON THE USER — only the user can lift the pause; no user
hint lifting it has arrived. The planner therefore cannot pivot routes this iter.

### Proposed iter-228 objective (1 file ≤ dispatch cap)

`Picard/TensorObjSubstrate.lean` [mode: mathlib-build], decomposed:
- **PRIMARY** — build the C-bridge toward `dual_isLocallyTrivial` (lower-risk, verbatim mirror of
  the CLOSED `tensorObj_restrict_iso`; H2′ already built). Land as many axiom-clean sub-pieces as
  possible (the restrict-iso first, then `dual_isLocallyTrivial`).
- **SECONDARY** — if C lands axiom-clean and budget remains, begin the A-engine's load-bearing
  sub-piece `localSection` (with its naturality field) as a standalone axiom-clean lemma. Do NOT
  attempt the full `homOfLocalCompat` or pin any sorry.

## Your question

Per route, return CONVERGING / CHURNING / STUCK / UNCLEAR. Specifically assess:
1. Is decomposing into "C-bridge primary (mirror-build, H2′ done) + localSection secondary" a
   genuine convergence step, or is it the same helper-accretion pattern under a new label?
2. Given the deep risk (d.2) is confirmed avoided and the remainder is bounded engineering, does
   the 11-iter no-sorry-elim signal still warrant STUCK, or is bottom-up infra-building expected
   to show a flat project-sorry counter until the final assembly?
3. Dispatch-sanity: 1 file, ≤ cap, all other lanes correctly HELD — OK?
If your verdict is STUCK/CHURNING, name the corrective TYPE. Note explicitly: the planner's
ability to act on a "route pivot" corrective is gated on a USER decision (the pause), already
escalated — so if you prescribe pivot, say what the planner should do THIS iter given it cannot
pivot unilaterally and must not idle.
