# Strategy Critic Report

## Slug
iter010

## Iteration
010

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — the end-state `Hⁱ(f_* C•) ≅ (pushforward f).rightDerived i F`
  matches the frozen `Nonempty (… ≅ higherDirectImage f i F)`. The P4 engine is built and
  axiom-clean; applying it to the relative augmented Čech complex is the right shape.
- **Mathematical soundness**: PARTIAL — the *engine* (P4: a G-acyclic resolution computes
  `RⁱG`) is sound and done. The *inputs* it needs are not actually supplied by the planned
  means. Specifically, Route A requires **termwise `(pushforward f)`-acyclicity** of
  `Cᵖ = ∏ (j_s)_*(F|_{U_s})`, i.e. `R�q f_* Cᵖ = 0` for `q>0`. Localising to affine `V ⊆ S`,
  this is `H�q((f∘j_s)⁻¹V, F) = Hq(U_s ×_S V, F)` with `U_s ×_S V` affine (f separated) — so it
  reduces to **absolute affine vanishing** `Hq(affine, qcoh) = 0`. The strategy treats affine
  vanishing as an available/cheap "Mathlib need," but it is neither in Mathlib (verified below)
  nor supplied by any construction the strategy plans to build. See the bridge route and the
  infrastructure-deferral finding — this is the same gap.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — `lemma-injective-trivial-cech` (injective
  `O_X`-modules are Čech-acyclic) and a Čech↔derived comparison/dimension-shift. The goal
  requires it (every acyclicity input bottoms out here); no route builds it — it is explicitly
  on the "do NOT formalize" list. Detailed below.
- **Phantom prerequisites**: "affine Serre vanishing" is listed in P5a's Key-Mathlib-needs as
  though it were an off-the-shelf input. It is not in Mathlib and not constructed by the plan.
- **Effort honesty**: under-counted — the irreducible Čech↔derived bridge
  (`lemma-injective-trivial-cech` + a `lemma-cech-vanish`-style dimension shift, plus a
  basis/cofinality step to restrict to standard covers) is unbudgeted; it sits in neither the
  P3 nor the P5a LOC/iter estimate.
- **Parallelism under-exploited**: no — the file-split standing directive in Open Qs already
  addresses this.
- **Verdict**: CHALLENGE

### Route: B — two spectral sequences (REJECTED, fallback)

- **Verdict**: SOUND — correctly rejected as strictly heavier for the same `Nonempty` goal.
  One note (not a challenge): Route B's Grothendieck/Čech spectral sequence rests on exactly
  the same irreducible brick — `lemma-injective-trivial-cech` — that Route A also needs but
  currently denies needing. So the rejection of B does not let the project escape that brick;
  it only avoids the *second* (Leray) spectral sequence and the quasi-coherence-of `Rqf_*` input.

### Route: P3-narrowing ↔ P5a-basis-lemma bridge (load-bearing)

- **Goal-alignment**: PASS — narrowing the non-protected `CechAcyclic.affine` to standard
  covers does not touch the frozen signature; routing the general `𝒰` through the basis lemma
  is the right idea *if the basis lemma holds*.
- **Mathematical soundness**: FAIL (as written) — the strategy's proof of the basis lemma is
  circular. The plan: "apply `lem:acyclic_resolution_computes_derived` with `G = Γ(B,-)` to the
  augmented Čech complex of a standard cover, **term-acyclicity from the same prime-local
  contracting homotopy** as `lem:cech_acyclic_affine`." The contracting homotopy proves the
  *complex* `0 → F → C•` is exact (a resolution). It says **nothing** about acyclicity of the
  *terms*. Term-acyclicity for `G = Γ(B,-)` is `Hq(B, (j_σ)_*(F|_{D(f_σ)})) = Hq(D(f_σ), F) =
  0` — i.e. **affine vanishing on the smaller affine `D(f_σ)`**, which is the very statement
  being proved. There is no induction on `D(f_σ)` (localizations of an arbitrary affine are
  again arbitrary affines), so the argument is a circular regress. Confirmed against Stacks:
  `lemma-quasi-coherent-affine-cohomology-zero` (02KG, `stacks-coherent.tex:145`) is *not*
  proved from the contracting homotopy — it is proved by feeding the standard-cover Čech
  vanishing (the homotopy lemma 02FD, `stacks-coherent.tex:44`) **into** `lemma-cech-vanish-basis`
  (01EO), whose proof needs `lemma-ses-cech-h1` + `lemma-injective-trivial-cech`
  (`stacks-cohomology.tex:1696,1593,1408`). The homotopy alone is provably insufficient.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — same as Route A.
- **Phantom prerequisites**: the claim "term-acyclicity from the contracting homotopy" asserts
  a derivation that does not exist.
- **Effort honesty**: under-counted (same unbudgeted bridge).
- **Verdict**: CHALLENGE

## Format compliance

- **Size**: 117 lines / 11617 bytes — within budget (≤250 lines / ≤12 KB), but ~95 % of the
  byte budget; little headroom.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`,
  `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
  (`## References index` / `## Blueprint summary` / `## Prior critique status` belong to the
  *directive*, not STRATEGY.md.)
- **Per-iter narrative detected**: yes — 5 in-prose iter references (`.archon/STRATEGY.md`
  lines 19, 66, 72, 85, 87): e.g. `"RESOLVED scoping (iter-009)"`, `"DONE iter-009
  (blueprint-writer de-spectral-sequenced …)"`, `"a FRESH whole-blueprint gate review … done
  iter-010"`. This is iter history that belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no — completed phases are in `## Completed`; no excised routes
  linger. `## Completed` cells (Reusable techniques / Pitfalls) are long but single-line —
  borderline, watch for growth.
- **Table discipline**: PASS — both tables well-formed.
- **Format verdict**: DRIFTED — strip the iter-NNN narrative from `## Open strategic questions`
  (and line 19) into the iter sidecar.

## Infrastructure-deferral findings

### Deferred: `lemma-injective-trivial-cech` (injectives are Čech-acyclic) + a Čech↔derived comparison/dimension-shift

- **Required by goal**: yes — every acyclicity input the goal needs (the basis lemma's
  term-acyclicity, and Route A's termwise `f_*`-acyclicity) reduces to affine vanishing
  `Hq(affine, qcoh)=0`, and affine vanishing cannot be obtained from the contracting homotopy
  alone. Crossing from "the explicit localization complex is exact" to "derived/sheaf
  cohomology vanishes" is exactly this lemma. Since `higherDirectImage` is *defined* via
  `rightDerived` (injective resolutions), any comparison of the Čech complex to `rightDerived`
  must factor through "injective ⟹ Čech-acyclic" (`stacks-cohomology.tex:1408`, used by both
  the spectral-sequence route `:1573` and the elementary dimension-shift `lemma-cech-vanish`
  `:1630`). It is irreducible.
- **Current plan for building it**: none — explicitly on the "do NOT formalize" list ("do NOT
  formalize the general Stacks-01EO bootstrap … lemma-cech-h1, lemma-kill-cohomology-class,
  lemma-ses-cech-h1, lemma-injective-trivial-cech"). The strategy believes the contracting
  homotopy + P4 substitutes for it; it does not.
- **Timeline**: absent.
- **Verdict**: CHALLENGE (escalates toward REJECT-of-current-plan: the goal is unreachable on
  the plan as written, though it remains *achievable* once this brick is added — hence
  CHALLENGE, not REJECT of the project).

## Alternative routes (suggested)

### Alternative: build the minimal Čech↔derived bridge, keep P4/Route A otherwise intact

- **What it looks like**: formalize `lemma-injective-trivial-cech` (injective `O_X`-module ⟹
  Čech complex exact in degrees `>0`) — short in Stacks: an injective module is injective in
  presheaves, whose Čech cohomology is computed by `lemma-cech-cohomology-derived-presheaves`.
  Then use the *elementary* dimension-shift `lemma-cech-vanish` (`stacks-cohomology.tex:1630`)
  — embed `F ↪ I` injective, `Q = I/F`, use `lemma-ses-cech-h1` so the SES is exact on
  presheaves, dimension-shift the long exact sequence. This needs `lemma-ses-cech-h1` but
  **NOT** the torsor identification `lemma-cech-h1` nor `lemma-kill-cohomology-class`. Combined
  with the standard-cover homotopy vanishing (P3) and a cofinality-on-a-basis step, this gives
  affine vanishing legitimately, and feeds Route A's term-/relative-acyclicity inputs.
- **Why it might be cheaper or sounder**: it is *sound* (the planned shortcut is not), and it is
  markedly lighter than the full 01EO bootstrap the strategy feared — it drops the torsor and
  kill-cohomology-class sub-theory. So the strategy's instinct to avoid the *full* 01EO is
  correct; the error is concluding it needs **no** bridge at all.
- **What the current strategy may have rejected**: it conflated "avoid the full 01EO bootstrap"
  with "avoid `lemma-injective-trivial-cech`," lumping the irreducible brick in with the
  avoidable sub-theory.
- **Severity of the omission**: critical.

## Prerequisite verification

- `Hq(affine scheme, quasi-coherent) = 0` for `O_X`-modules: MISSING (leansearch returns only
  generic affine-scheme API; no cohomology-vanishing result) — confirms the gap is real and
  project-side.
- `lemma-injective-trivial-cech` analog for `Scheme.Modules` / ringed-space `O_X`-modules:
  MISSING (Mathlib's site cohomology is `Sheaf J AddCommGrpCat`, wrong category, as the
  strategy itself notes) — must be built.
- P4 prerequisites (`Functor.rightDerived`, `InjectiveResolution.isoRightDerivedObj`,
  `HasInjectiveResolutions`): VERIFIED (P4 compiles axiom-clean per `## Completed`).

## Must-fix-this-iter

- Route A: CHALLENGE — its acyclicity inputs (termwise `f_*`-acyclicity, basis-lemma
  term-acyclicity) are not supplied by the planned contracting homotopy; they reduce to affine
  vanishing, which needs the deferred bridge. Add the bridge to the plan with a concrete LOC/iter
  estimate, or rebut.
- Route (bridge): CHALLENGE — the claim "term-acyclicity from the prime-local contracting
  homotopy" is circular. Replace it in STRATEGY.md with a sound derivation (the alternative
  above) or an explicit rebuttal in `plan.md`.
- Infrastructure-deferral CHALLENGE: `lemma-injective-trivial-cech` + a Čech↔derived
  dimension-shift is required by the goal and currently on the "do NOT formalize" list with no
  timeline. Either build it this iter (or scope it as a phase with an iter estimate) or produce
  a concrete plan. Note: the *full* 01EO bootstrap (torsors, kill-cohomology-class) can still be
  avoided — only this brick is irreducible.
- Format: DRIFTED — move the 5 iter-NNN narrative references (lines 19, 66, 72, 85, 87) out of
  STRATEGY.md into the iter sidecar; watch the byte budget (~95 % used).

## Overall verdict

The P4 engine and the choice of Route A over Route B are sound, and the goal is achievable —
but the strategy defers `lemma-injective-trivial-cech` (the Čech↔derived bridge), which is
required for the stated goal. The central load-bearing claim — that the basis lemma and the
termwise acyclicity inputs follow "from the prime-local contracting homotopy" via P4 — is
mathematically circular: the homotopy proves the Čech *complex* is exact, but the *terms'*
G-acyclicity is itself affine vanishing `Hq(affine,qcoh)=0`, the very thing being proved, and
there is no induction to ground the regress. Affine vanishing is absent from Mathlib (verified),
so it must be built project-side, and every route to it crosses "injectives are Čech-acyclic."
The strategy correctly avoids the *full* 01EO/torsor bootstrap, but wrongly concludes it needs
no bridge at all. The planner must, this iter, either fold the minimal bridge
(`lemma-injective-trivial-cech` + a `lemma-cech-vanish`-style dimension shift + standard-cover
cofinality) into the plan with an honest estimate, or record an explicit rebuttal showing a
non-circular source for term-/relative-acyclicity. Format is DRIFTED on per-iter narrative only.
