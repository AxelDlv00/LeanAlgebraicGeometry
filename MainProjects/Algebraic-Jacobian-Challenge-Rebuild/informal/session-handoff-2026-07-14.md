# Session handoff — 2026-07-13/14 (interactive Fable session)

For the next agent continuing the `rebuild` task. Supersedes
`session-handoff-2026-07-12.md` (whose gotchas remain valid; re-read its "Operating
model" — unchanged except: Fable SUBAGENTS now author the keystone bricks, per the
user's standing instruction, with the Fable main loop doing specs/audits/commits only).

## What landed (all committed, kernel-green, axiom-clean; ~17 ledger commits)

**The (C1) campaign is CLOSED**: `PicEtAff.unit_injective` (Kleiman 2.5(1)) —
coherent witness (ζ2·i, rebuilt kernel-checkable after the monolith died in kernel
timeouts), pi-assembly with the class equation (ζ2·ii, Fable-authored), the ζ3
reduction + Čech kernel lemma + close (Fable-authored). Blueprinted end-to-end
(155-node cone under the headline).

**Layer-2 `picEt` landed in full** (Fable-authored): affine-opens limit, glue
functoriality by the unique-pullback-value characterization, affine comparison,
functor laws, Zariski sheaf property of the plus. I-0140 closed and archived.

**Wave-2b χ-ledger foundations** (divisor-first — the roadmap's earlier twisted-route
wording was corrected; see `informal/zeta-w2b-chi-recon.md`): Dedekind colength engine,
Scheme.ord/residueDeg, curve divisors, skyscraper package incl. H¹(sky)=0.
Continuation (G3-residual → G9) running at handoff time — check `horizon task` comments.

**(C2) first landing**: rigidification calculus (lm:idn both ways, the UNCONDITIONAL
on-the-nose rigidified descent equation, lm:aut ring heart) + `picEtUnit` complete.
**Design correction**: the (C2) finish is fppf EFFECTIVITY along `cg` on the curve
product — campaign-scale (mirror of ζ2/ζ3), the recon's one-shot finish was wrong.
Precise frontier + suggested route in the C2 agent report (task comments) and
`Picard/Rigidification.lean` docstrings.

## State of the plan

Structured roadmap: `horizon roadmap list`, tree under `AJCR.jacobian` (waves with
subitems, statuses current). Wave 3: (C1) done, Layer-2 done, (C2) first landing +
effectivity campaign open, degree/Pic⁰ UNBLOCKED (its shared prerequisite `picEtUnit`
landed; also needs the χ-ledger for the degree map). Then Wave 4 (representability —
the open risk; early-warning brick = cohomology-and-base-change-lite; plan-B = Weil
symmetric-power construction, plan-C = old-tree FGA), Waves 5–7 per the roadmap
summaries. Čech: curve-level only by design; full engine port is the blocked
contingency item `AJCR.cech-port`.

## Recons/specs on disk (informal/)

`zeta-w2b-chi-recon.md` (χ-ledger, G1–G12 map), `zeta-c2-rigidification-recon.md`
((C2) — §3 G3 sketch CORRECTED by the C2 report), `spec-layer2-picEt.md`,
`spec-zeta3-close.md`, `spec-zeta2iib-pi-assembly.md` (all executed).

## Operating protocol that worked (keep it)

One prover at a time (single build lock; lake vs LSP races corrupt package
materialization — see memory). Spec → launch (Fable for keystones, Opus for
volume/recon/blueprint) → independent audit (no-op root build + sorry census +
own lean_verify on the headline) → `horizon commit` per brick → blueprint agent
per brick (read-before-cite; validate parse, 0 dangling) → roadmap/task comments.
Resume agents via SendMessage for continuations (context carries).

## The kernel/elaboration discipline (non-negotiable, earned the hard way)

Opaque `def`s for repeated covers/cochains/carriers + named ≤-lemmas; abstract
lemmas (small types) instantiated once for anything rewrite-heavy; NEVER
`rw`/`simp only ... at` over hypotheses mentioning concrete curve/Spec towers;
`(kernel) deterministic timeout` ignores maxHeartbeats — restructure, don't raise;
doc-comments go AFTER `set_option ... in`; no binders with local-notation types in
`variable` commands (declarations silently vanish — verify per-constant);
`mapAlg`-based statements with explicit k-AlgHoms (instance-`map` fails at section
rings); consume `picEtMap` only through the ∃!-API; term-mode congrArg/Eq.trans
across restrictScalars/Units.map seams.

## Next bricks, in order

1. χ-ledger continuation (running): G3-residual, G4-residual, G5, G7, G8, G9.
2. degree/Pic⁰ interface (`AJCR.picard.degree`): consumes `picEtUnit` + the ledger;
   recon first (the (C2) recon §2.7 lists what's missing: divisorClass, deg_divisorClass,
   pic0Functor).
3. (C2) effectivity campaign: needs a Fable design pass FIRST (worksheet like the (C1)
   one) — route sketch in the C2 report; do not launch a prover on it without the
   worksheet.
4. Wave 4 early-warning brick: cohomology-and-base-change-lite recon.
