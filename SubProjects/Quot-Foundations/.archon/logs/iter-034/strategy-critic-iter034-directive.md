# Strategy-critic directive — iter-034

Fresh-context review of the project strategy. Read ONLY the inputs named here; do NOT read
PROGRESS.md, task_*.md, iter sidecars, or prover/review narrative.

## Inputs to read
- `STRATEGY.md` (verbatim — the strategy under review; just edited this iter for the FBC-A pivot).
- `references/summary.md` (the reference index).
- Blueprint chapter list (titles + one-line topics): run
  `for f in blueprint/src/chapters/*.tex; do echo "$f"; grep -m1 -E '\\\\chapter|\\\\section' "$f"; done`
  — or read the first ~10 lines of each chapter for its topic.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): (FBC) the i=0 flat
base-change map `g^* f_* F ⟶ f'_* g'^* F` is an iso; (GF) generic flatness `thm:generic_flatness`
with algebraic core done; (QUOT) the Quot/Grassmannian definitions, predicates, and
`thm:grassmannian_representable`. End state: zero project sorry in the closure, kernel-only axioms.

## Focus questions for this review
1. **FBC-A pivot soundness.** STRATEGY now swaps FBC-A from "direct-on-sections" to "mate re-encoding"
   (`mateEquiv`/`conjugateEquiv` for composite adjunctions, Seam-1 mechanism one layer up). Is this a
   sound route to `IsIso pushforwardBaseChangeMap` for the affine case, or is there a structurally
   simpler path (e.g. is the whole affine lemma a corollary of an existing Mathlib base-change-of-`H⁰`
   result, or of the module-level `regroupEquiv` plus a cleaner transport)? Challenge the re-encoding
   if a shorter route exists.
2. **FBC-B parallelism.** FBC-B is now ACTIVE-parallel with a build-ahead `eqLocus` sub-lane independent
   of the affine sorry. Is the H⁰-as-equalizer globalization the right decomposition, and is the
   `tensorEqLocusEquiv` (flat preserves equalizer) anchor the correct Mathlib hook?
3. **gap1 / QUOT spine.** The C→P1→D→assembly spine for gap1 (QCoh≃Mod affine descent). Any circularity
   or missing prerequisite, especially around D (`section_localization_descent`, Stacks tag to confirm)?
4. **Estimations.** Are the `Iters left` / LOC cells defensible given the pivot resets FBC-A?

You may NOT be silently ignored: if you CHALLENGE a route, the planner must rebut or amend STRATEGY.
