# Iter-157 plan-agent run

## Headline outcome

Iter-157 is the **route-(c) grounding + architecture-decision iter**. The user supplied
three canonical sources (Mumford *Abelian Varieties*, Hartshorne, FGA Explained); the iter
registered them, used them to harden the committed genus-0 route (c), and decided the file
architecture that breaks the import cycle blocking the keystone. The central technical
result of the iter: **the route-(c) entry is the cube-free Rigidity Lemma**, not the
theorem of the cube — a major cost reduction the strategy-critic asked for and the
reference-retriever confirmed from Mumford §4 p.43.

No critical-path proof prover this iter (mechanical gate: the route-(c) chapter is being
brought to prover-ready detail + the importable Lean target does not yet exist). Instead the
iter builds the prover-ready blueprint + (if review clears) the importable scaffold, so the
**iter-158 prover checkpoint** (bound by the progress-critic) can fire.

## Wave 1 (parallel) — 3 mandatory critics + reference-retriever

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| reference-retriever | register-new-sources | COMPLETE | Registered Mumford / Hartshorne / FGA (pointer cards + summary + deep page maps). KEY: Mumford Rigidity Lemma (Form I) §4 p.43 is **cube-free**; "ℙ¹→A constant" is a *consequence* of it (not separately labelled — Milne Prop 3.10 packages it). Both Mumford + Hartshorne PDFs are SCANNED (no text layer → verbatim quotes need rendered-image reads). Hartshorne genus-0≅ℙ¹ = Ex IV.1.3.5. |
| strategy-critic | route-c-architecture | **CHALLENGE (route c) + Route A SOUND** | Commitment to (c) is correct but for an unstated reason: **char-freeness**. The cheap concrete-ℙ¹ `df=0` route (iter-155 does NOT actually refute it — `H⁰(ℙ¹,Ω)=H⁰(ℙ¹,O(−2))=0` is elementary) dies on a char-`p` Frobenius wall; the cube route sidesteps it. Must-fix: cost the cube prerequisites honestly, add the genus-0⟹ℙ¹ Riemann–Roch line-item, soften "low-risk half", record the char-freeness decision. ALL addressed in STRATEGY.md this iter. |
| progress-critic | genus0-route-c | **STUCK (managed)** | Keystone open ~8 iters across 2 framings; but the iter-156 pivot + iter-157 scaffold-refactor is the correct corrective. Binds a HARD CHECKPOINT: **iter-158 MUST fire a prover** at the scaffolded declaration, else CHURNING → route-pivot/cheaper-route. Recorded below + in PROGRESS.md. |
| blueprint-reviewer | iter157 | **Jacobian.tex + RigidityKbar.tex partial (must-fix); 9/11 clean** | Route (c) committed in Jacobian.tex but un-wired, statement-thin (cube/rational-map-extends), `\lean{}`-less, and absent from RigidityKbar.tex (still df=0). Architecture call: **give route (c) its OWN chapter + upstream Lean file**, NOT a consolidated cover. Confirmed covers-path fix (full repo-root paths). |

## Decision made

**Commit the route-(c) minimal chain in a NEW dedicated chapter + upstream Lean file;
defer the theorem of the cube unless it proves unavoidable.**

- **Architecture.** New `AlgebraicJacobian/AbelianVarietyRigidity.lean` (imports `Genus`,
  imported by `Jacobian`) + its own 1:1 chapter `AbelianVarietyRigidity.tex`. This breaks
  the `RigidityKbar → Rigidity → Jacobian` cycle that prevented `genusZeroWitness` from
  consuming the keystone. The old `rigidity_over_kbar` (in `RigidityKbar.lean`, `[CharZero]`)
  becomes the fallback-(a) artifact, kept in tree. (blueprint-reviewer's separate-chapter
  recommendation, NOT a consolidated cover — so the heavy route-(c) verdict can't gate the
  clean `Jacobian.lean` projection declarations.)
- **Minimal chain (cube-free first).** Entry = the **Rigidity Lemma** (Mumford Form I,
  cube-free properness argument), blueprinted to prover-ready detail; then `ℙ¹→A constant`
  (likely from the rigidity lemma alone), `genus-0+k̄-pt ⟹ ≅ℙ¹` (Hartshorne, flagged as a
  Riemann–Roch sub-build), and the headline `rigidity_genus0_curve_to_AV` (char-free).
  Theorem of the cube kept only as a DEFERRED deep input if `ℙ¹→A` genuinely needs it.
- **Why (c) over the cheap-ℙ¹ `df=0` route:** char-freeness (the protected goal is
  arbitrary `[Field k]`; `df=0 ⟹ constant` is false in char `p` without Frobenius descent).
  Recorded in STRATEGY.md Routes (c).
- **Cheapest reversal signal:** if the blueprint-writer finds `ℙ¹→A constant` *requires*
  the full theorem of the cube (not just the rigidity lemma), the genus-0 cost balloons to
  representability-scale — at which point reconsider route (b) (engine byproduct) since the
  cube-laden (c) loses its decoupling advantage.

## Hard checkpoint (progress-critic, binding)

**iter-158 MUST dispatch a prover** at the scaffolded `AbelianVarietyRigidity.lean`
declaration (the Rigidity Lemma entry). If iter-158 is another plan/blueprint/refactor
round with no prover on this route, the route flips to CHURNING and the corrective
escalates to route-pivot / cheaper-route search. Cumulative keystone budget: ~8 iters
elapsed + ~6–12 estimated — route (c) is the last affordable framing before user-escalation.

## Wave 2 — blueprint-writer (new chapter) + STRATEGY-MODIFYING FINDING

`av-rigidity-chapter` → COMPLETE. Created `AbelianVarietyRigidity.tex` (own chapter, covers
the new Lean file), grounding the minimal chain in Mumford (rigidity lemma p.54, cube p.66),
Hartshorne (genus-0≅ℙ¹ p.314), Milne (Prop 3.10 p.26) — verbatim from rendered scanned pages.

**STRATEGY-MODIFYING FINDING (absorbed into STRATEGY.md before any Lean work):** the
single-ℙ¹ base case `ℙ¹→A constant` is **NOT cube-free** — the OPPOSITE of the iter-156 hope.
The Rigidity Lemma + the multi-factor induction (Cor 1.5) are cube-free, but the base case
("an AV has no rational curves") rests irreducibly on the theorem of the cube (char-free; the
char-0 `df=0` shortcut is the rejected Frobenius-wall route). So the cube is the dominant
route-(c) cost — but it is SHARED with Route A's Albanese UP, so route (c) stays cheaper than
(b) (= cube AND representability) and the commitment holds. `rigidity_lemma` is cube-free +
prover-ready; the cube is the next heavy keystone.

## Wave 3 — Jacobian strip (writer) ∥ scaffold (refactor), then fast-path re-review

- `blueprint-writer jacobian-strip` → COMPLETE. Deleted the duplicate route-(c) subsection
  from Jacobian.tex, redirected all crefs to the new chapter, landed the 3 carry-over NOTE
  corrections (uniqueness epi-cancellation; C.2.f multi-iter re-cost; import-cycle honesty),
  removed the consumed `% NOTE:` blocks. No duplicate labels; LaTeX balanced.
- `refactor scaffold-av-rigidity` → COMPLETE. Created `AlgebraicJacobian/AbelianVarietyRigidity.lean`
  (imports only `Genus`; cycle broken), 4 declarations as `sorry`, headline pinned verbatim to
  `rigidity_over_kbar` minus `[CharZero]`. **`lake build` GREEN (8332 jobs), no new axioms.**
- `blueprint-reviewer av-rigidity-fastpath` → **GATE CLEARS.** `AbelianVarietyRigidity.tex`
  `complete: true` + `correct: true`, no must-fix; Jacobian.tex + RigidityKbar.tex clean.
  Authorizes a prover lane on `rigidity_lemma` ALONE (siblings deferred/blocked).

## Prover dispatch THIS iter (fast-path)

Per the fast-path rule (writer round + green build + scoped re-review clears C), I add
`AbelianVarietyRigidity.lean` to `## Current Objectives` THIS iter, scoped to `rigidity_lemma`
only. This fires the prover at the cube-free entry a full iter ahead of the progress-critic's
iter-158 checkpoint — scaffold AND prove-lane in one iter. A single DEEP lane.

## Edits made by the plan agent directly
- STRATEGY.md: route-(c) phase row re-costed (cube-free rigidity lemma entry, genus-0⟹ℙ¹
  bridge, cube as deferred deep input); Routes (c) records the char-freeness decisive
  reason + cube-avoidance open question; architecture decision (new upstream file + own
  chapter); new-material entry; cumulative budget.
- content.tex: added `\input{chapters/AbelianVarietyRigidity}`.
- RigidityKbar.tex: fixed `% archon:covers` to full repo-root paths (doctor must-fix);
  added a STRATEGY NOTE redirecting the committed route to the new chapter and reframing
  this chapter as the fallback-(a) home (resolves the route-mismatch must-fix).

## Follow-ups recorded (not this iter)
- RigidityKbar.tex `thm:rigidity_over_kbar` stale Mumford `% SOURCE` (claims paywalled;
  Mumford now bundled) — refresh with a verbatim quote (fallback declaration, "soon",
  off active prover path).
- `references/hartshorne-algebraic-geometry.md` card mis-describes Exercise IV.1.3 (says
  "genus-0 + rational pt ⇒ ≅ℙ¹"; actually that is Example IV.1.3.5 — Ex IV.1.3 is a
  non-proper-regular-curve-is-affine exercise). Writer flagged it; the chapter cited the
  correct Example. Have the reference-retriever correct the card in a later iter.
- The Jacobian.tex carry-over NOTE corrections (uniqueness epi-cancellation; C.2.f descent
  re-cost; import-cycle honesty) were LANDED this iter by the jacobian-strip writer (NOT
  deferred). The C.2.f descent itself remains a multi-iter base-change sub-build (gated).
- "rename them correctly" (user hint): the three filenames (`mumford-abelian-varieties`,
  `hartshorne-algebraic-geometry`, `fga-explained`) were already correct slugs; I kept them
  and registered cards + summary rows. If the user wanted different names, a hint will say.

## Subagent skips
- (none — all 3 highly-recommended critics dispatched.)
