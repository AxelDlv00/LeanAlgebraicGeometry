You are surveying an existing Lean 4 codebase for reusable material. READ-ONLY: do not edit any file.

Context: In `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge` (project AJC) the file `AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean` has three `sorry`s:
 - line ~421 `pullback_preservesMonomorphisms` (flat pullback of O-modules preserves monos)
 - line ~1922 the `naturality` field of `cech_pushforward_baseChange_natIso`
 - line ~1993 the `naturality` field of `twisted_cech_nerve_iso`
The latter two are cosimplicial naturality squares for Cech nerve base change (compatibility of degreewise base-change isomorphisms with the index-omission / coface maps on cover intersections).

The sibling project `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild` (AJCR) has a ~60-file `AlgebraicJacobian/Cohomology/` directory and a *completed* Cech port. There may also be other sibling projects under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/` and `/home/axel/LeanAlgebraicGeometry-Horizon/SubProjects/` (e.g. `Cech-Cohomology`).

YOUR TASK — answer these questions concretely, with file:line citations and exact declaration names/signatures:

1. Does any sibling project contain a proved (sorry-free) statement that the pullback of sheaves of modules along a FLAT morphism of schemes preserves monomorphisms, preserves finite limits, is exact, or has a stalk / sections description on ARBITRARY (not necessarily quasi-coherent) modules? Search for names containing `pullback` together with `Mono`, `Exact`, `FiniteLimits`, `stalk`. Also look for any stalk model of `SheafOfModules.pullback` or `PresheafOfModules.pullback`.

2. Does any sibling project contain Cech-nerve base-change material with the cosimplicial naturality PROVED — i.e. a natural isomorphism of cosimplicial objects (or of functors `CosimplicialObject`) comparing `g^*` applied to a Cech nerve/complex with the Cech nerve of a base-changed cover? Look for names containing `cech` + `baseChange`, `cosimplicial`, `nerve`, `coverInter`, `pushPull`. Report whether the naturality proofs exist and what technique they use (e.g. `ext` + `simp` on section-level, Hom.ext, uniqueness of maps out of a colimit, `Sheaf.hom_ext`, adjunction uniqueness).

3. Any general-purpose lemma in a sibling project (or in AJC itself) of the form "two morphisms of sheaves of modules agree if they agree on sections / on an affine cover / after composing with a mono / by adjunction uniqueness" that would be the natural tool for proving such a naturality square. Give exact names and signatures.

4. Any lemma about `IsQuasicoherent` being closed under kernels/cokernels/images, or that the inclusion of quasi-coherent sheaves reflects/creates limits, in AJC or a sibling.

Method: use `grep -rn` for names, and read the relevant declarations. You may also use the horizon search index: `"$HORIZON_BIN" search "<query>" --json` (binary at /home/axel/.archon-env/bin/horizon) which spans all projects and mathlib; output is a JSON list of objects with `name`, `library`, `signature`.

Deliver a compact report: for each of the 4 questions, either "nothing found" or the exact names + file:line + a one-line note on reusability. Do not speculate about mathematics; report what is on disk.
