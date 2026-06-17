# Strategy critic directive — iter-199 (slug: `route199`)

## STRATEGY.md (verbatim — current state at iter-199 entry)

(See `.archon/STRATEGY.md` — file is unchanged from iter-198 except
for minor status refresh on Lane WD-A4a, Lane T32, and the carrier-
soundness probe verdict commitment. The iter-198 strategy-critic
returned CHALLENGE with 6 must-fix items; all 6 were addressed in
iter-198 by STRATEGY.md edits. This iter-199 re-dispatch is to
re-verify the addressed challenges are still credibly closed and to
audit any new strategic drift.)

The full content of STRATEGY.md is in `.archon/STRATEGY.md` (252
lines). Read it verbatim.

## References summary (verbatim)

(See `.archon/references/summary.md`.)

## Blueprint summary (chapter titles + one-line topic)

- `AbelianVarietyRigidity.tex` — Route C / paused; rigidity lemma
  over k̄.
- `AbelJacobi.tex` — final Abel-Jacobi cone declaration.
- `Albanese_AlbaneseUP.tex` — Albanese UP via Sym^g divisor map;
  Route C dependency flagged iter-199.
- `Albanese_AuslanderBuchsbaum.tex` — Stacks 090V; depth, pd, AB
  formula. iter-198 closed gap (4) `lemma-depth-drops-by-one`;
  gaps (1)-(3) remain.
- `Albanese_CodimOneExtension.tex` — Stacks 00TT smooth ⇒ regular
  local stalk; Milne Thm 3.1 codim-1 extension; Lemma 3.3 codim-1
  indeterminacy. Stage 6 sub-gaps (i)-(ii.A)-(ii.B) — (i) closed
  iter-198, (ii.A)+(ii.B) remain.
- `Albanese_CoheightBridge.tex` — Krull-dim ↔ coheight bridge;
  axiom-clean.
- `Albanese_Thm32RationalMapExtension.tex` — Milne Thm 3.2;
  rational ⇒ regular. Two sorries (L155, L294); L155 re-routed as
  Lane COE derivative iter-198.
- `Cohomology_*.tex` — cohomology infrastructure substrates.
- `Differentials.tex` — Kähler differentials.
- `Genus.tex` — genus definition.
- `Genus0BaseObjects/*.tex` — Route C / paused; genus-0 ℙ¹
  scaffolding.
- `Jacobian.tex` — final Jacobian declaration.
- `Picard_FGAPicRepresentability.tex` — Pic representability under
  carrier-soundness probe; iter-198 fga-sorry-order added per-sorry
  closure rank-1/2/3 partition.
- `Picard_FlatteningStratification.tex` — A.2.a bypassed via
  Cartier route.
- `Picard_IdentityComponent.tex` — A.3.i excised; substrate carrier
  for degComp foundations.
- `Picard_LineBundlePullback.tex` — A.1.b; DONE iter-188.
- `Picard_Pic0AbelianVariety.tex` — Pic⁰ as AV; A.3 row.
- `Picard_QuotScheme.tex` — A.2.b bypassed via Cartier route.
- `Picard_RelativeSpec.tex` — A.1.a; complete iter-185.
- `Picard_RelPicFunctor.tex` — A.1.c relative Pic functor;
  iter-198 dispatched 5 placeholder closures (PicSharp, functorial,
  presheaf, etSheaf, etSheaf_group_structure); placeholder NOTE
  pending iter-199 writer dispatch.
- `RiemannRoch_*.tex` — Route C / paused (excluding
  `RiemannRoch_WeilDivisor.tex` which is hybrid, with A.4.a
  substrate in scope).
- `Rigidity.tex` — projective rigidity over a field.
- `RigidityKbar.tex` — Route C / paused.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean.ref`): nine protected declarations
headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese /
Jacobian object uniform over the k-rational pointing of a smooth
proper geometrically irreducible curve `C / k`, no `C(k) ≠ ∅`
hypothesis. End-state contract: every protected declaration verifies
with `#print axioms` returning the kernel triple
{propext, Classical.choice, Quot.sound} only — zero inline `sorry`
in the dependency cone of any protected decl, no project axioms
reachable. Files outside the cone may carry sorries provided their
declarations do not transitively feed any protected decl.

## Re-verification question

The iter-198 strategy-critic CHALLENGE returned 6 must-fix items:

1. **Route C REJECT (goal-coherence)** — addressed iter-198 by
   restating Goal as cone-scoped + adding "Genus-0 arm — Route A
   zero-dim group-scheme argument" subsection.
2. **A.2.c "Cartier route" CHALLENGE** — addressed iter-198 by
   acknowledging substrate-block on Route C and moving A.2.c to
   priority-4 conditional under carrier-soundness probe.
3. **Genus-0 witness CHALLENGE** — addressed iter-198 by spelling
   out the 8-step lemma chain.
4. **A.3.vii effort honesty CHALLENGE** — addressed iter-198 by
   widening A.3.ii / A.3.vii to ~300-600 LOC.
5. **Carrier-soundness probe abort criterion CHALLENGE** —
   addressed iter-198 by naming specific decls + axiom triple +
   FAIL trigger + rollback target.
6. **Format DRIFTED** — addressed iter-198 by stripping per-iter
   narrative + dropping A.1.a row + moving probe row out of
   phases table.

**Your task**: re-read STRATEGY.md and verify each of the 6
addressed items is still credibly closed. Specifically:

- Is the cone-scoped Goal coherent with the iter-199 plan-phase
  action of HELDING Route C? Or does the cone-audit deferral to
  iter-199+ make this a latent REJECT?
- Is the A.2.c "substrate-blocked on Route C" framing actually
  workable, or does it license indefinite typeclass-abstraction
  loops without representability ever landing?
- Is the genus-0 arm's 8-step lemma chain truly Route-C-independent,
  given the iter-198 blueprint-reviewer flagged
  `lem:symmetric_product_to_jacobian`'s hidden Route C dependency
  on RR (now NOTE-flagged in `Albanese_AlbaneseUP.tex` iter-199 by
  the plan agent)?
- Is the carrier-soundness probe verdict CONFIRM (per iter-198
  review) consistent with the abort criterion? Per the criterion,
  the probe fails if any consumer shows `sorryAx`. The iter-198
  RPF `functorial` declaration DID inherit `sorryAx` from the file-
  local `addCommGroup` sorry. Is this the same "consumer"
  contemplated in the abort criterion, or a different
  (legitimate-leak) case?

Plus: identify any NEW strategic findings that emerged from
iter-198's outcomes:

- Lane WD-A4a structural blocker (typeclass strength
  [IsLocallyNoetherian] vs [IsNoetherian]) — is the iter-199
  substrate-only-under-stronger-hypothesis path consistent with
  Route A bottom-up, or does it create a parallel A.4.a phase that
  needs separate strategy modeling?
- Lane T32 re-routing as Lane COE derivative — does this widen the
  effective Lane COE cost beyond ~300-500 LOC?
- Lane RPF placeholder closures — is the strategy to "leave them
  + add NOTE markers" coherent, or should iter-199+ revert the
  placeholders (since they will require body replacement once
  Mathlib `Scheme.Modules.tensorObj` lands)?

Return your verdict (SOUND / CHALLENGE / REJECT) with explicit
reference to each item above. If CHALLENGE, name the specific
sentence(s) of STRATEGY.md needing edit.
