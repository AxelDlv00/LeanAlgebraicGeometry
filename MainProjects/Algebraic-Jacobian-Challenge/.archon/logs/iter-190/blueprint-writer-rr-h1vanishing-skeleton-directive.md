# Blueprint writer directive — `RiemannRoch_H1Vanishing.tex` (NEW chapter)

## Target chapter

`blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — NEW file. The
corresponding Lean file `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
does NOT exist yet; this chapter pins the declarations the iter-191+
prover will scaffold. The chapter must use `\label{chap:RR_H1Vanishing}`
as the top-level label so the existing broken `\cref{chap:RR_H1Vanishing}`
in `RiemannRoch_RRFormula.tex` resolves.

## Strategy context

This chapter covers STRATEGY.md sub-phase **Genus-0 RR.2.H¹** — the
skyscraper-flasque-cohomology vanishing argument needed for the H¹
half of the genus-0 Euler characteristic on a smooth proper curve over
an algebraically closed field. The chapter is on the **critical path**:
the genus definition `g(C) := dim_k H¹(C, O_C)` uses H¹ directly, and
the RR.2 χ-additivity assembly (parent
`lem:eulerCharacteristic_skyscraperSheaf` in
`RiemannRoch_RRFormula.tex`) depends on the H¹ half closing.

Per the iter-188 strategy revision, this sub-phase was promoted from
"off path" to a committed project-side build (~200-400 LOC over
~8-12 iters). Mathlib does NOT have general Serre duality for curves
nor flasque-sheaf H¹ vanishing in a form directly consumable for
skyscraper sheaves on noetherian curves.

The chapter feeds two iter-190+ prover targets:
- `RiemannRoch/RRFormula.lean` Lane H, lemma
  `lem:H1_skyscraperSheaf_finrank_eq_zero` — currently a Tier-3 typed
  sorry whose body closes by reducing to the chapter's main result.
- `RiemannRoch/OCofP.lean` Lane A downstream sorries
  (`h1_vanishing_genusZero` at L1154, etc.) — closure of the H¹
  vanishing for `O_C` on a genus-0 curve enables the RR.3 chain that
  produces a non-constant section.

## What to include

### Section structure (proposed)

1. **§1 Setup and motivation.** Spell out that the chapter is the
   project-side build of "H¹(C, F) = 0 for F skyscraper-supported on a
   single closed point of a smooth proper curve C over an algebraically
   closed field, encoded via the project's
   `Scheme.HModule`/`HModule'` cohomology" (the project's
   ModuleCat-k-valued Ext-flavoured cohomology — see
   `Cohomology/StructureSheafModuleK.lean` for the API). Cite the
   chapter as resolving the `\cref{chap:RR_H1Vanishing}` reference
   currently dangling in `RiemannRoch_RRFormula.tex`.

2. **§2 Flasque sheaves on noetherian curves and their cohomology
   vanishing.** Pin the main result:
   `lem:H1_vanishing_flasque_on_noetherian_curve` —
   `H¹(C, F) = 0` for a flasque sheaf `F` on a noetherian scheme `C`.
   Sources: Hartshorne III §1 Prop. 1.4 (flasque sheaves are acyclic),
   III §2 Prop. 2.5 (flasque modules have H^i = 0 for i ≥ 1). Quote
   verbatim from the local PDF (`references/hartshorne-algebraic-geometry.pdf`)
   per the citation discipline.

3. **§3 Skyscraper sheaves are flasque.** Pin
   `lem:skyscraperSheaf_isFlasque` — a skyscraper sheaf supported at a
   single closed point is flasque. Argue via direct check on
   restriction maps. Mathlib has `TopCat.Presheaf.Skyscraper` and
   `Flasque.of_skyscraper` may exist (verify); if not, this is project-
   side ~20-40 LOC.

4. **§4 H¹ of a skyscraper sheaf on a noetherian curve vanishes.**
   Pin `lem:H1_skyscraperSheaf_finrank_eq_zero` —
   `Module.finrank k (H¹(C, skyscraper)) = 0` —
   AS THE MAIN OUTPUT consumed by `RiemannRoch_RRFormula.tex`. This
   lemma's `\lean{...}` pin points at the existing Lean declaration
   in `RiemannRoch/RRFormula.lean` (the lemma is already declared
   there with a Tier-3 typed sorry body; the iter-190+ prover will
   replace that sorry with a body consuming the chapter's
   §2 + §3 main lemmas). Confirm the pin name by checking
   `RiemannRoch/RRFormula.lean` for the existing declaration.

5. **§5 Lean encoding and dependencies.** Name the future Lean target
   `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (file to be
   scaffolded iter-191+). List declarations:
   - `Scheme.IsFlasque` (predicate; or use Mathlib's if it exists)
   - `Scheme.HModule.h1_flasque_eq_zero` (or naming consistent with
     the project's HModule API)
   - `Scheme.HModule.h1_skyscraperSheaf_finrank_eq_zero` (as listed
     above)

   For each, give the Lean signature mock-up so the iter-191 prover
   can scaffold from the chapter directly.

### Sources to cite

The chapter MUST follow the project's citation discipline. Required
`% SOURCE:`/`% SOURCE QUOTE:`/`\textit{Source: ...}` block for each
non-bespoke declaration. Open the local sources:

- `references/hartshorne-algebraic-geometry.pdf` (Hartshorne, GTM 52)
  for the flasque-cohomology-vanishing argument (Ch III §1-2). PDF is
  a scanned image with offset +17; the relevant pages are around
  document p.~207 (Prop. 1.4) and p.~209 (Prop. 2.5).
- `references/stacks-coherent.tex` (Stacks ch.30) if you find a
  cleaner Stacks tag pointer (tags 01EH+ for sheaf cohomology). The
  Stacks file is in tex; just open and grep.

Verbatim quotes per the project's discipline.

### Lean target naming

The chapter's `\lean{...}` pins should reference declarations in either
the existing `RiemannRoch/RRFormula.lean` (for
`lem:H1_skyscraperSheaf_finrank_eq_zero`, which already exists there as
a typed sorry) or the planned `RiemannRoch/H1Vanishing.lean` (for the
flasque-vanishing helpers). Where the planned Lean file has not been
scaffolded yet, pin with the intended fully-qualified name; the iter-191
prover will scaffold to match.

## What NOT to include

- **NO `\leanok` markers anywhere.** The deterministic `sync_leanok`
  phase manages `\leanok` based on actual Lean sorry status. Your
  directive must not instruct on markers; just include the
  `\lean{...}` pin so the sync agent can find each declaration.
- **NO `\mathlibok` markers.** The review agent applies these.
- **NO Lean tactic code in the proof sketches.** Proof sketches are
  mathematical prose. The iter-191+ prover translates them.
- **NO `\notready` markers** anywhere — that's review-agent territory.

## Out-of-scope items for this chapter

- The downstream RR.2 χ-additivity assembly (lives in
  `RiemannRoch_RRFormula.tex`).
- Serre duality in general (the chapter uses flasqueness directly,
  not Serre duality, per Hartshorne's order of presentation).
- General coherent-sheaf cohomology vanishing (would need Grothendieck
  vanishing or projective-dimension arguments; this chapter narrows to
  the skyscraper/flasque case).

## Strategy-modifying findings

If during drafting you find that the flasque-on-noetherian-curve
argument actually requires a different substrate (e.g. soft sheaves
instead of flasque, or a direct Čech-cohomology calculation), STOP and
record under `## Strategy-modifying findings` in your report. The
planner will revise STRATEGY.md before any prover work on this chapter
starts.

## Reference retriever authorization

If you find you need a source not already in `references/` (e.g.
Stacks tag 01EH+ chapters, Liu's algebraic geometry textbook chapter
on flasque sheaves), you are authorized to spawn the reference-
retriever subagent (the dispatcher has set `references/**` in your
write-domain). Wait for the retrieved file to land before quoting.

## Length target

~150-250 lines of LaTeX. Comparable to `RiemannRoch_OCofP.tex` or
`RiemannRoch_WeilDivisor.tex` for the depth this sub-phase justifies.
