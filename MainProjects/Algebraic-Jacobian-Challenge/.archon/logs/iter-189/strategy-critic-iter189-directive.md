# Strategy Critic Directive

## Slug
iter189

## Project goal

Formalize Christian Merten's "Algebraic Jacobian Challenge"
(`references/challenge.lean.ref`): 9 protected declarations headlined by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` —
existence of an Albanese / Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible
curve `C / k`, with **no** `C(k) ≠ ∅` hypothesis. End-state: zero
inline `sorry`, kernel-only axioms only. Char-general: `[Field k]`
only — NO `CharZero`.

## STRATEGY.md (verbatim)

(Read `.archon/STRATEGY.md` at the project root for the canonical
current strategy. It is 150 lines / 12 KB and follows the canonical
skeleton: `## Goal`, `## Phases & estimations`, `## Routes`,
`## Open strategic questions`, `## Mathlib gaps & new material`.)

The strategy was MAJOR-REVISED iter-188 per your prior CHALLENGE:

1. **A.3 decomposition (was your CHALLENGE)**: decomposed A.3 into 7
   sub-phases (A.3.i `GroupScheme.IdentityComponent`,
   A.3.ii `Pic⁰_{C/k}` def, A.3.iii tangent iso, A.3.iv smoothness,
   A.3.v properness, A.3.vi geom-irred, A.3.vii degree map).
2. **A.4.d Sym^g pivot (was your CHALLENGE)**: pivoted from Sym^g
   symmetric-power UP to **divisor-map Albanese UP** (universal
   effective divisor → Pic^d morphism + degree-g line bundle
   translate). Saves S_g-quotient gap.
3. **RR.2 H¹ promotion (was your CHALLENGE)**: promoted RR.2 H¹
   skyscraper-flasque vanishing from "off critical path" to committed
   **RR.2.H¹** project-side sub-phase (~8-12 iters / ~200-400 LOC).
4. **Axiomatise-then-replace REMOVED (was your CHALLENGE)**: the
   permanent suspended-decision state was excised per your finding.
5. **Format compliance**: stripped iter-NNN narrative from Status
   cells; trimmed STRATEGY.md to 12.0 KB; removed Prior critique block.

iter-188 plan-phase ALSO landed Option (c) for Lane M↓: accept narrow
named typed sorry `isRegularLocalRing_stalk_of_smooth` as permanent
until Mathlib upstream of Smooth → `IsRegularLocalRing`. Lane M↓
declared COMPLETE-EXCEPT-UPSTREAM-GAP.

## References index

`references/summary.md` lists:

- `challenge.lean.ref` — Merten's protected signatures (authoritative).
- `stacks-varieties.md` / `stacks-fields.md` / `stacks-algebra.md` /
  `stacks-coherent.md` / `stacks-constructions.md` — relevant Stacks
  chapters for substrate work.
- `kleiman-picard.md` → `kleiman-picard.pdf` / `-src/` — FGA Pic.
- `nitsure-hilbert-quot.md` → `.pdf` / `-src/` — Quot/Hilbert.
- `abelian-varieties.md` → `abelian-varieties.pdf` — Milne course notes
  (Rigidity Thm 1.1; Thm 3.2/Prop 3.10; AlbaneseUP Prop 6.1/6.4).
- `mumford-abelian-varieties.md` → `.pdf` — Mumford AV.

## Blueprint summary (chapter titles + one-line topics)

(One line per chapter under `blueprint/src/chapters/`)

- `AbelianVarietyRigidity.tex` — Genus-0 chart-bridge cross01; III.c
  separated-locus path (substrate falsification iter-188; chapter
  has `% NOTE` flagging missing Mathlib lemma).
- `AbelJacobi.tex` — terminal AbelJacobi-witness assembly.
- `Albanese_AlbaneseUP.tex` — divisor-map Albanese UP (REWRITE PENDING
  this iter per A.4.d pivot).
- `Albanese_AuslanderBuchsbaum.tex` — A.4.b Auslander–Buchsbaum.
- `Albanese_CodimOneExtension.tex` — Lane M↓ (Option c committed).
- `Albanese_CoheightBridge.tex` — codim-≥2 bridge.
- `Albanese_Thm32RationalMapExtension.tex` — Milne 3.2 (branch 2 gated).
- `Cohomology_*.tex` — Mayer-Vietoris, structure sheaves.
- `Genus0BaseObjects_*.tex` — ℙ¹ base objects.
- `Genus.tex` — `genus C := dim_k H^1(C, O_C)`.
- `Jacobian.tex` — terminal `Jacobian` object.
- `Picard_FGAPicRepresentability.tex` — A.2.c FGA assembly.
- `Picard_FlatteningStratification.tex` — A.2.a.
- `Picard_IdentityComponent.tex` — A.3.i.
- `Picard_LineBundlePullback.tex` — A.1.b (SOLVED iter-188).
- `Picard_QuotScheme.tex` — A.2.b.iii.
- `Picard_RelativeSpec.tex` — A.1.a.
- `Picard_RelPicFunctor.tex` — A.1.c.
- `Rigidity.tex` — RigidityLemma + Cor 1.5 + Cor 1.2.
- `RiemannRoch_OCofP.tex` — RR.3 (sections of `O_C(P)`).
- `RiemannRoch_OcOfD.tex` — `O_C(D)` for arbitrary divisor (BLOCKED).
- `RiemannRoch_RationalCurveIso.tex` — RR.4 ℙ¹ iso.
- `RiemannRoch_RRFormula.tex` — RR.2 χ-skyscraper.
- `RiemannRoch_WeilDivisor.tex` — RR.1 Weil divisor API.

## Question for you

Re-audit STRATEGY.md (read it fresh — verbatim — at
`.archon/STRATEGY.md`) for:

1. **Have the iter-188 revisions adequately addressed your prior
   CHALLENGE?** Are the A.3 decomposition, A.4.d pivot, RR.2.H¹
   promotion, axiomatise-then-replace removal, format compliance all
   coherent and complete?

2. **Is the genus-0 arm still viable?** iter-188 surfaced that
   `IsClosedImmersion.lift_iff_range_subset` is NOT in Mathlib at
   b80f227 (verified by Lane B prover), so the (III.c) separated-locus
   chart-bridge path now needs ~150-200 LOC project-side substrate
   over 3-5 iters (planner-committed Option B per USER ESCALATION
   default). Does this change the genus-0 cost calculus enough that an
   alternative chart-bridge approach (or even Route C deferral) should
   be on the table?

3. **A.4.d divisor-map UP** — pivoted from Sym^g per your prior
   CHALLENGE. Is the divisor-map route mathematically as well-defined
   as the Sym^g route? Are there hidden dependencies that the planner
   missed? `Albanese_AlbaneseUP.tex` rewrite is scheduled this iter.

4. **Lane M↓ Option (c) commitment**: the `isRegularLocalRing_stalk_of_smooth`
   typed sorry is now permanent until Mathlib upstream. The Open Q
   records this. Is this commitment acceptable for the end-state
   contract ("zero inline sorry, kernel-only axioms"), or does it
   compromise the contract in a way that requires either (a) a
   STRATEGY.md fix or (b) an alternative project-side build (Stacks
   00TT formalisation, ~200-300 LOC over 4-6 iters)?

5. **A.3.ii–A.3.vi unstarted phases**: per your prior CHALLENGE these
   are now decomposed into separate sub-phases. iter-189 plan-phase
   schedules `blueprint-writer Picard_Pic0AbelianVariety.tex` for
   A.3.ii-vii coverage. Is the proposed decomposition order
   (A.3.ii → A.3.iii → A.3.iv → A.3.v → A.3.vi → A.3.vii) sound, or
   should the dependency graph be redrawn?

6. **`nonempty_jacobianWitness` final assembly**: gated on both
   genus-0 + positive-genus arms. With the new RR.2.H¹ commitment +
   Option B substrate commitment, what is the realistic top-line
   estimate for end-state, in iters and LOC? STRATEGY.md currently
   says ~280-500 iters / ~9000-16000 LOC (Route A) + ~40-60 iters /
   ~2080-3700 LOC (Route C). Is this still credible?

You may write notes on iter sidecars, but please DO NOT read iter
sidecars, PROGRESS.md, task_pending.md, or prover/reviewer reports —
your value is the fresh view.
