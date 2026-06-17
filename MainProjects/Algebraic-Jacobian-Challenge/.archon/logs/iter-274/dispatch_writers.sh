#!/usr/bin/env bash
cd /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge
DIR=.archon/logs/iter-274
declare -A CH=(
 [thm32]=Albanese_Thm32RationalMapExtension.tex
 [cechhdi]=Cohomology_CechHigherDirectImage.tex
 [mayervietoris]=Cohomology_MayerVietoris.tex
 [ssmk]=Cohomology_StructureSheafModuleK.tex
 [rigiditykbar]=RigidityKbar.tex
 [grpobj]=AlgebraicJacobian_Cotangent_GrpObj.tex
 [jacobian]=Jacobian.tex
 [flatstrat]=Picard_FlatteningStratification.tex
 [lbc]=Picard_LineBundleCoherence.tex
 [lbp]=Picard_LineBundlePullback.tex
 [rpf]=Picard_RelPicFunctor.tex
 [rrformula]=RiemannRoch_RRFormula.tex
 [rci]=RiemannRoch_RationalCurveIso.tex
 [weildivisor]=RiemannRoch_WeilDivisor.tex
)
run_one() {
  local slug="$1" chapter="$2"
  python3 .claude/tools/archon-subagent.py \
    --name blueprint-writer \
    --slug "cov274-${slug}" \
    --directive-file "$DIR/dag-writer-${slug}-directive.md" \
    --write-domain "blueprint/src/chapters/${chapter}" \
    > "$DIR/dispatch-${slug}.log" 2>&1
  echo "DONE cov274-${slug} (exit $?)"
}
export -f run_one
export DIR
# 4-way parallel
printf '%s\n' \
 "thm32 ${CH[thm32]}" \
 "cechhdi ${CH[cechhdi]}" \
 "mayervietoris ${CH[mayervietoris]}" \
 "ssmk ${CH[ssmk]}" \
 "rigiditykbar ${CH[rigiditykbar]}" \
 "grpobj ${CH[grpobj]}" \
 "jacobian ${CH[jacobian]}" \
 "flatstrat ${CH[flatstrat]}" \
 "lbc ${CH[lbc]}" \
 "lbp ${CH[lbp]}" \
 "rpf ${CH[rpf]}" \
 "rrformula ${CH[rrformula]}" \
 "rci ${CH[rci]}" \
 "weildivisor ${CH[weildivisor]}" \
 | xargs -P 4 -n 1 -I {} bash -c 'set -- {}; run_one "$1" "$2"'
echo "ALL WRITERS DONE"
