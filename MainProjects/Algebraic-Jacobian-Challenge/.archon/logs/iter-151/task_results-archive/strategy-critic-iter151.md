# Strategy Critic Report

## Slug
iter151

## Iteration
151

## Routes audited

### Route: Route C (M2 critical path) — chart-algebra piece (ii)

- **Goal-alignment**: PARTIAL — Route C produces the rigidity needed for the
  *pointed* genus-0 case (ℙ¹ → trivial Jacobian), but the strategy's framing of
  how genus-0 closes is internally inconsistent (see below).
- **Mathematical soundness**: PASS — `Γ(X,𝒪) ≅ k` for proper geom-irreducible
  smooth `X/k` via the (S3.sep.*)/(S3.pi.*) separable/purely-inseparable split is
  standard and correctly attributed (Stacks 056T / 0BUG / 02KH / 030K). The
  `H⁰(ℙ¹,Ω) = 0` via 2-chart Mayer–Vietoris (avoiding Serre duality) is also
  correct (Ω_{ℙ¹}=𝒪(-2) has no global sections).
- **Sunk-cost reasoning detected**: no — the iter-151 "bright-line" is the
  *opposite* of sunk cost: it is an explicit stop-loss (no further
  sorry-inflating decomposition; one sanctioned close-out, then STUCK→pivot).
  Good discipline.
- **Phantom prerequisites**: `RingHom.iterateFrobenius_comm` — could not locate
  (base `iterateFrobenius` and `iterateFrobenius_add` exist; the `_comm`
  variant does not). Char-p is parked, and Open-questions admits it is "not yet
  scaffolded", so this is disclosed, not hidden — but the Phases table lists it
  under "Key Mathlib needs" as if it were an existing dependency.
- **Effort honesty**: reasonable — 380–800 LOC remaining for the chart-algebra
  envelope and 150–250 for the flat-base-change-of-Γ blocker are defensible.
- **Verdict**: CHALLENGE — not for the math, but for the spine-framing gap (see
  Must-fix). The "genus-0 closes via the vacuity branch" claim materially
  undersells what Route C is for.

### Route: Route A (M3 off-critical-path) — Picard scheme via FGA

- **Goal-alignment**: PASS — `positiveGenusWitness` via the Picard scheme is the
  right object for *pointed* positive-genus curves (e.g. an elliptic curve over
  ℚ genuinely demands a non-trivial Jacobian), which the protected ∀-signature
  must cover.
- **Mathematical soundness**: PASS — the dependency chain (Nitsure Quot/Hilbert
  → Kleiman `th:main` §4 → `prp:P0`/`lem:agps` §5 → `ex:jac`) is the standard
  Grothendieck/FGA construction. The claim that `ex:jac` is irreducibly routed
  through `th:main` and hence the full Quot/Hilbert engine is correct along
  Kleiman's route; the only escape (Symⁿ/Abel–Jacobi bypassing Pic
  representability = Route B) is correctly identified and its rejection is sound.
- **Sunk-cost reasoning detected**: no.
- **Effort honesty**: reasonable-but-likely-under-counted on the engine. The
  re-scope arithmetic is internally consistent (6070→5100: A1 3775 unchanged,
  A2 1320→800, A3 975→500). The *re-scope itself is honest* — it explicitly says
  the user's "far less work" hypothesis is only PARTIALLY supported, that the
  reduction is the structural tail (A2/A3), and that the existence engine cannot
  be trimmed. That candor is exactly right. My one caveat: A1 ≈ 3775 LOC for
  *full Quot/Hilbert representability from current Mathlib* (which ships
  essentially zero Quot-scheme / flattening-stratification / Castelnuovo–Mumford
  infrastructure) is plausibly an under-count, not an over-count, and 40–70
  iters may likewise be optimistic. This does not change the verdict because the
  mass is disclosed as "largest pure-Mathlib-build sub-project / irreducible",
  not concealed.
- **Verdict**: SOUND — the re-scope is honest and ~5100 is defensible as a
  midpoint *given Kleiman's route*; flag the A1 figure as a floor, not a ceiling.

### Route: Alternative — over-k̄ + Galois descent for M2.a

- **Verdict**: SOUND — correctly self-labelled DECORATIVE (no concrete
  descent-infra LOC bid, fpqc-descent-of-morphisms is a real Mathlib gap), so it
  is honestly kept out of the decision loop rather than padding the strategy.

### Route: Hybrid pivot (analogist-recommended) — CharZero + MvPolynomial

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — `MvPolynomial.mkDerivation` + `pderiv` for
  the KDM (BR.5) joint-kernel collapse is verified to exist, and the closely
  related `KaehlerDifferential.mvPolynomialBasis_repr_D` is in Mathlib, so the
  live path rests on real infrastructure. `IsAlgClosed.algebraMap_bijective_of_isIntegral`
  (the ~15-LOC HYBRID-(A) lemma) is verified to exist exactly as named.
- **Verdict**: SOUND — the three analogues are honestly status-tagged (C live,
  B parked on a consumer wall, A user-gated) and the H1Cotangent name-collision
  trap is correctly discarded.

## Format compliance

- **Size**: 253 lines / 14989 bytes — **over budget** on both axes (~250 lines,
  ~12 KB; bytes are ~25% over).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Representative verbatim:
  "**Bright-line (iter-151, per CHURNING verdict).** Route C has run 5
  consecutive PARTIAL iters with NET sorry count UP (5→9 …)"; "**Kleiman
  re-scope finding (iter-151, read from `kleiman-picard.pdf`).**"; "Iter-149
  status: four first-class scaffolds, 0/4 bodies closed."; "(analogist iter-150
  pivot)"; "iter-150 closed the FREE-CASE + lift + functoriality"; "re-posed
  iter-151, unanswered since iter-150"; "revert the iter-127 over-k commitment".
  This is the DRIFT the directive asked me to watch for: per-iter momentum is
  leaking into the stable end-state document.
- **Accumulation detected**: no (material) — closed chart-algebra sub-pieces are
  correctly summarised out to the iter sidecar; the file does track only
  remaining work. The bloat is narrative, not excised-route carcasses.
- **Table discipline**: PASS — `## Phases & estimations` is a proper table with
  the named columns.
- **Format verdict**: NON-COMPLIANT — the skeleton is intact but the document is
  over budget *and* saturated with date-stamped iter narrative. Per the
  skeleton's own rule, per-iter narrative is a CHALLENGE-level finding requiring
  in-place restructure this iter.

## Prerequisite verification

- `MvPolynomial.mkDerivation`: VERIFIED (Mathlib.Algebra.MvPolynomial.Derivation).
- `MvPolynomial.pderiv`: VERIFIED (via `pderiv_def`).
- `KaehlerDifferential.mvPolynomialBasis_repr_D`: VERIFIED (bonus support for the KDM path).
- `IsAlgClosed.algebraMap_bijective_of_isIntegral`: VERIFIED (Mathlib.FieldTheory.IsAlgClosed.Basic).
- `iterateFrobenius`: VERIFIED (base map + `_add`/`_def` lemmas exist).
- `RingHom.iterateFrobenius_comm`: MISSING — no `_comm` variant located; this is
  project-to-build (char-p is parked, so non-blocking, but should not be listed
  as an existing "Key Mathlib need").

## Must-fix-this-iter

- **Route C / spine framing — CHALLENGE.** The strategy says (lines 121–123) the
  genus-0 critical path "closes via the vacuity branch" and (lines 14–16) that
  the protected ∀-over-`P` signature is "handled via the vacuity branch". This is
  internally inconsistent with what Route C actually does. The relevant axis is
  **pointed vs. unpointed**, not genus-0 vs. positive:
  - *Unpointed* curves (e.g. Brauer–Severi conics): no `P : 𝟙 ⟶ C`, the
    Albanese-for-`P` property is vacuous — this is the genuine vacuity branch.
  - *Pointed* genus-0 (⟹ ℙ¹): the property is **non-vacuous** and forces the
    rigidity argument that *is the entire Route C chart-algebra effort*. Calling
    this "the vacuity branch" tells a fresh reader Route C is unnecessary, which
    is false.
  Concrete edit: in `## Goal`, replace the single "vacuity branch" sentence with
  the two-case split (unpointed ⇒ vacuous Nonempty witness; pointed ⇒ real
  per-`P` property), and in `## Routes` state that Route C's load-bearing content
  is the *non-vacuous pointed-ℙ¹ rigidity*, not vacuity.
- **Route A scope vs. the same axis — CHALLENGE (resolve together).** If the
  vacuity branch is genuinely available for unpointed curves, it applies to
  *unpointed positive-genus* curves too — yet the strategy routes **all**
  positive genus through the ~5100-LOC Picard engine. Either (i) `positiveGenusWitness`
  need invoke Route A only for the *pointed* positive-genus sub-case (which would
  narrow Route A's obligation and should be stated), or (ii) the witness object
  must be a real Jacobian even when `C(k)=∅`, in which case the genus-0 path does
  **not** close "via the vacuity branch" either and the Goal framing is simply
  wrong. The strategy cannot have it both ways. Concrete edit: add one sentence
  to `## Routes` stating, against the protected signature in `challenge.lean`,
  whether the witness object is existentially bound *outside* the `∀ P` (vacuity
  available for any pointless `C`, Route A needed only for pointed positive
  genus) or *inside/independently* (Route A needed unconditionally, and the
  genus-0 "vacuity" claim must be deleted).
- **Format: NON-COMPLIANT** — restructure STRATEGY.md in-place this iter. Two
  most impactful deviations: (1) strip every `iter-NNN` / "this iter" /
  date-stamped finding ("Bright-line (iter-151…)", "Kleiman re-scope finding
  (iter-151…)", "iter-149 status", "iter-150 closed…", "revert the iter-127
  commitment") to `iter/iter-151/plan.md`, keeping only the *standing* decision
  in STRATEGY.md (e.g. "Route C tolerates no further sorry-inflating
  decomposition; sole sanctioned step = KDM transfer close-out; failure ⇒ pivot"
  with no iter stamps); (2) the resulting trim should also bring the file back
  under the ~12 KB / ~250-line budget.
- **Phantom prerequisite `RingHom.iterateFrobenius_comm`** — relabel as
  project-to-build (it is not in Mathlib), or drop from the "Key Mathlib needs"
  column.

## Overall verdict

A fresh mathematician would judge the *mathematics* of this strategy sound and
the Route-A re-scope notably honest — the planner resisted the temptation to
inflate the user's "far less work" hypothesis and correctly localised the
shrinkage to the A2/A3 tail while declaring the existence engine irreducible;
~5100 is a defensible midpoint (if anything the A1 engine is a floor). The
chart-algebra and KDM paths rest on verified Mathlib infrastructure. But two
material concerns block an as-is approval. First and most important, the
genus-0/positive-genus spine is described in terms of a "vacuity branch" that
does not actually carry the genus-0 case: the real axis is pointed-vs-unpointed,
and the strategy must say plainly whether vacuity is available for *any*
pointless curve (narrowing Route A to pointed positive genus) or for none
(deleting the genus-0 vacuity claim) — the current text quietly assumes both.
Second, the document has drifted: it is over budget and saturated with
date-stamped iter narrative that belongs in the sidecar, and that drift is a
must-fix-in-place this iter.
