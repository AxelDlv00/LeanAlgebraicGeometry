You are a READ-ONLY census agent in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon. Two Lean 4 projects: MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR, root module AlgebraicJacobian) and MainProjects/Algebraic-Jacobian-Challenge (AJC). Do NOT edit any file. Report exact declaration names, files and line numbers, plus the FULL statement (binders included) of each hit.

CONTEXT. I need to prove, in AJCR, for a genus-0 curve C over a field k and an ARBITRARY commutative k-algebra A: a relative Picard class on C_A whose degree is 0 at every field point of Spec A is pulled back from Spec A (i.e. trivial in `relPic C (overSpec k A)`). The classical proof is cohomology-and-base-change: fibrewise degree 0 + genus 0 gives H^1(fibre) = 0 and h^0 = 1, so π_*L is invertible and the evaluation map π^*π_*L → L is an isomorphism.

CENSUS THESE FOUR THINGS, in BOTH projects (use `"$HORIZON_BIN" search "<words>" --json` — it indexes both projects AND mathlib — plus targeted grep once you have a name):

1. RELATIVE H^0 / PUSHFORWARD of a line bundle or module sheaf on a relative curve over a base RING: any declaration producing `Module.Finite`/`Module.Projective`/rank-1 statements for relative sections. In particular the "rigid engine" cone in AJCR (files AlgebraicJacobian/Cohomology/RigidEngine*.lean, roadmap rows AJCR.w4-rep.rigid.re0..re5) — give me the TOP-LEVEL consumable theorems with their exact hypotheses, and say plainly which twist/object they are about (are they about an arbitrary line bundle on C_R, or only about specific Θ_n twists of a specific chart family?).

2. Anything of the form "a line bundle trivial on every fibre (or of fibrewise degree 0) is pulled back from the base" / "π_*L is invertible" / EVALUATION map `π^*π_*L → L` being an isomorphism, in either project or mathlib.

3. AJCR's own cohomology-and-base-change layer: roadmap row AJCR.w4-rep.cbc is marked done — find which files and which theorems that row actually landed, and state exactly what they conclude and over what base (field? ring? which flatness hypotheses?).

4. AJC's cohomology-and-base-change cone (roadmap AJC.cohomology): list its landed top-level theorems with statements, and judge concretely how self-contained they are (what do they import from AJC-specific structures that AJCR lacks?).

Also report: does either project contain ANY statement about `Pic` of projective space / P^1 over a RING (not a field)?

Be exhaustive on names but terse in prose. Your final message is the report: a list of hits, each with name, file:line, full statement, and one line on usability for the goal above. End with a 5-line summary naming the SHORTEST existing path (if any) to "fibrewise degree 0 over a ring implies pulled back", and what is genuinely missing.
