# Strategy critic — iter-079

Read ONLY: `.archon/STRATEGY.md` (verbatim), `references/summary.md`, and the blueprint chapter
titles below. Do NOT read iter sidecars, task_*.md, PROGRESS.md, or any prover/review narrative.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): flat base change i=0 (FBC),
generic flatness (GF, DONE), and the Quot foundations (QUOT defs + Grassmannian representability).
End-state: zero project `sorry` in the 29-node closure, zero project axioms, kernel-only axioms.
Names/labels are the parent's for merge-back.

## Blueprint chapter titles
- Cohomology_FlatBaseChange — flat base change of pushforward (i=0) [FBC, PARKED]
- Cohomology_RegroupHelper — regrouping iso for affine base-change tensor tower [done]
- Picard_FlatteningStratification — flattening stratification / generic flatness [GF, done]
- Picard_GlueDescent — effective descent: restriction of glued sheaf to a chart [ACTIVE]
- Picard_GrassmannianCells — the Grassmannian over ℤ (cells, cocycle, glue, sep, proper) [done]
- Picard_GrassmannianQuot — tautological quotient + universal property of Gr [ACTIVE]
- Picard_QuotScheme — the Quot scheme (top-level defs, gated) [BLOCKED]
- Picard_RelativeSpec — relative Spec [support]
- Picard_SectionGradedRing — section graded ring: tensor powers + graded sections [SNAP, active]

## Ask
Fresh-mathematician review of the strategy. Specifically:
1. Is the GR-quot effective-descent route (glue `SheafOfModules` over `Scheme.GlueData`, then the
   Nitsure §5 inverse `grPointOfRankQuotient`) the right skeleton, vs Nitsure's actual §5 construction?
2. Is the SNAP route (associator → tensorPowAdd → sectionsMul_assoc_unit → graded assembly) sound and
   complete for what QUOT-defs needs?
3. Is FBC's indefinite PARK justified, or is there a canonical alternative route to the i=0 base-change
   iso the strategy is missing?
Verdict: SOUND / CHALLENGE / REJECT per route, with rationale.
